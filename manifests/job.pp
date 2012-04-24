define jenkins::job($builders_xml = '',
                    $scm_xml = '<scm class="hudson.scm.NullSCM"/>',
                    $cron_spec = '',
                    $child_projects = '') {

	file { "/home/soren/src/puppet-jenkins/new/jobs/${name}":
		ensure => directory,
	}

	file { "/home/soren/src/puppet-jenkins/new/jobs/${name}/config.xml":
		content => template("jenkins/config.xml.erb"),
#		owner => jenkins,
#		group => nogroup,
	}
}
