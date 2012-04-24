define jenkins::source_package($project, $flavor) {

    jenkins::job { "${project}-${flavor}-source-package":
        builders_xml => template("jenkins/${flavor}-source-package-builders.xml.erb")
    }

    jenkins::job { "${project}-${flavor}-packaging-branch":
        builders_xml => template("jenkins/${flavor}-packaging-builders.xml.erb")
    }
}
