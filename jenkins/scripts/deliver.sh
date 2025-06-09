#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name -Dstyle.color=never
set +x

echo 'The following command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
RAW_NAME=$(mvn -q -DforceStdout -Dstyle.color=never help:evaluate -Dexpression=project.name)
set +x

echo 'The following command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
RAW_VERSION=$(mvn -q -DforceStdout -Dstyle.color=never help:evaluate -Dexpression=project.version)
set +x

# Strip any ANSI escape codes or whitespace.
NAME=$(echo "$RAW_NAME" | sed 's/\x1b\[[0-9;]*m//g' | tr -d '\r\n')
VERSION=$(echo "$RAW_VERSION" | sed 's/\x1b\[[0-9;]*m//g' | tr -d '\r\n')

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
echo "Running: java -jar target/${NAME}-${VERSION}.jar"
set -x
java -jar "target/${NAME}-${VERSION}.jar"
