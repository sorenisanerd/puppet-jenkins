define jenkins::openstack_project::upstream_code() {
	$git_url = "https://github.com/openstack/${name}.git"
	$git_branch = "diablo/essex"
	jenkins::job { "${name}-upstream":
		builders_xml => template("jenkins/upstream-builders.xml.erb"),
		scm_xml => template("jenkins/git-scm.xml.erb"),
		cron_spec => '* * * * *',
		child_projects => "${name}-upstream-source-package, ${name}-cisco-source-package"
	}
}

define jenkins::openstack_project::cisco_branched_code() {
	$git_url = "https://github.com/CiscoSystems/${name}.git"
	$git_branch = "master"
	jenkins::job { "${name}-cisco":
		builders_xml => template("jenkins/upstream-builders.xml.erb"),
		scm_xml => template("jenkins/git-scm.xml.erb"),
		cron_spec => '* * * * *',
	}
}

define jenkins::openstack_project::upstream_packaging { 
	$bzr_url = "http://bazaar.launchpad.net/~openstack-ppa/${name}/ubuntu"
	jenkins::job { "${name}-upstream-packaging":
		scm_xml => template("jenkins/bzr-scm.xml.erb"),
		cron_spec => '* * * * *',
	    child_projects => "${name}-upstream-source-package"
	}
}

define jenkins::openstack_project::cisco_packaging { 
	$bzr_url = "http://bazaar.launchpad.net/~ciscosystems/${name}/ubuntu"
	jenkins::job { "${name}-cisco-packaging":
		scm_xml => template("jenkins/bzr-scm.xml.erb"),
		cron_spec => '* * * * *',
		child_projects => "${name}-cisco-source-package"
	}
}

define jenkins::openstack_project::upstream_source_package { 
	$bzr_url = "http://bazaar.launchpad.net/~ciscosystems/${name}/ubuntu"
	jenkins::job { "${name}-upstream-source-package":
        builders_xml => "    <hudson.plugins.parameterizedtrigger.TriggerBuilder>
      <configs>
        <hudson.plugins.parameterizedtrigger.BlockableBuildTriggerConfig>
          <configs>
            <hudson.plugins.parameterizedtrigger.PredefinedBuildParameters>
              <properties>project=${name}</properties>
            </hudson.plugins.parameterizedtrigger.PredefinedBuildParameters>
          </configs>
          <projects>upstream-source-package</projects>
          <condition>ALWAYS</condition>
          <triggerWithNoParameters>false</triggerWithNoParameters>
          <block>
            <buildStepFailureThreshold>
              <name>FAILURE</name>
              <ordinal>2</ordinal>
              <color>RED</color>
            </buildStepFailureThreshold>
            <unstableThreshold>
              <name>UNSTABLE</name>
              <ordinal>1</ordinal>
              <color>YELLOW</color>
            </unstableThreshold>
            <failureThreshold>
              <name>FAILURE</name>
              <ordinal>2</ordinal>
              <color>RED</color>
            </failureThreshold>
          </block>
          <buildAllNodesWithLabel>false</buildAllNodesWithLabel>
        </hudson.plugins.parameterizedtrigger.BlockableBuildTriggerConfig>
      </configs>
    </hudson.plugins.parameterizedtrigger.TriggerBuilder>"
	}
}

define jenkins::openstack_project::cisco_source_package { 
	$bzr_url = "http://bazaar.launchpad.net/~ciscosystems/${name}/ubuntu"
	jenkins::job { "${name}-cisco-source-package":
        builders_xml => "    <hudson.plugins.parameterizedtrigger.TriggerBuilder>
      <configs>
        <hudson.plugins.parameterizedtrigger.BlockableBuildTriggerConfig>
          <configs>
            <hudson.plugins.parameterizedtrigger.PredefinedBuildParameters>
              <properties>project=${name}
packaging_branch=http://bazaar.launchpad.net/~ciscosystems/${name}/ubuntu
</properties>
            </hudson.plugins.parameterizedtrigger.PredefinedBuildParameters>
          </configs>
          <projects>cisco-source-package</projects>
          <condition>ALWAYS</condition>
          <triggerWithNoParameters>false</triggerWithNoParameters>
          <block>
            <buildStepFailureThreshold>
              <name>FAILURE</name>
              <ordinal>2</ordinal>
              <color>RED</color>
            </buildStepFailureThreshold>
            <unstableThreshold>
              <name>UNSTABLE</name>
              <ordinal>1</ordinal>
              <color>YELLOW</color>
            </unstableThreshold>
            <failureThreshold>
              <name>FAILURE</name>
              <ordinal>2</ordinal>
              <color>RED</color>
            </failureThreshold>
          </block>
          <buildAllNodesWithLabel>false</buildAllNodesWithLabel>
        </hudson.plugins.parameterizedtrigger.BlockableBuildTriggerConfig>
      </configs>
    </hudson.plugins.parameterizedtrigger.TriggerBuilder>"
	}
}

define jenkins::openstack_project() {
	# Job to monitor upstream code repo
	jenkins::openstack_project::upstream_code { $name: }

	# Job to monitor Cisco branched code repo
	jenkins::openstack_project::cisco_branched_code { $name: }

	# Job to monitor upstream packaging
	jenkins::openstack_project::upstream_packaging { $name: }

	# Job to monitor Cisco's packaging
	jenkins::openstack_project::cisco_packaging { $name: }

    # Build "upstream" source packages
    jenkins::openstack_project::upstream_source_package { $name: }

    # Build Cisco source packages
    jenkins::openstack_project::cisco_source_package { $name: }
}
