packages:
  yum:
    java-1.7.0-openjdk: []
    java-1.7.0-openjdk-devel: []

commands:
  00_cue_changelog_download:
    command: cd /mnt/download && wget https://user4:economist@maven.escenic.com/com/escenic/changelog/changelog/2.0.0-3/changelog-2.0.0-3.zip
    test: [ ! -d /mnt/download ]
  01_cue_changelog_unzip: 
    command: mkdir /opt/escenic/ && chown -R escenic:escenic /opt/escenic/ && su - escenic && cd /opt/escenic/ && unzip /mnt/download/changelog-2.0.0-3.zip
    test: [ ! -d /opt/escenic/changelog-daemon-2.0.0-3 ]
  02_cue_changelog_start:
    command: cd /opt/escenic/changelog-daemon-2.0.0-3 && ./changelog.sh
    test: ps ax | grep -v grep | grep changelog.sh > /dev/null

files:
  /opt/escenic/changelog-daemon-2.0.0-3/config/Daemon.properties:
    mode: "000644"
    owner: root
    group: root
    content: |

      ########################################
      # The url to the change log
      #
      # Default:
      #  None
      ########################################
      url=http://ece-economist.economist.cue.cloud:8080/webservice/escenic/changelog/publication/6


      ########################################
      # The user name to use when accessing the change log
      #
      # Default:
      #  None
      ########################################
      username=user4


      ########################################
      # The password to use when accessing the change log
      #
      # Default:
      #  None
      ########################################
      password=economist

      ########################################
      # The nursery path to the agent to we should use when
      # consuming the change log
      #
      # Default:
      #  ./Agent
      ########################################
      #agent=

      ########################################
      # The folder where temporary failing entries will be stored
      #
      # Default:
      #  .temporary-errors
      ########################################
      #temporaryErrorsFolder=

      ########################################
      # The folder where permanent failing entries will be stored
      #
      # Default:
      #  .permanent-errors
      ########################################
      #permanentErrorsFolder=

      ########################################
      # Which direction to iterate the change log. Possible values :
      #  previous - from oldest to newest
      #  next - from newest to oldest
      #
      # Default:
      #  previous
      ########################################
      #direction=

      ########################################
      # How many seconds between each time we try to poll the change log.
      # The value must be larger than 0.
      #
      # Default:
      #  10
      ########################################
      #pollInterval=


      ########################################
      # How many seconds to wait before we start polling the change log.
      # The value must be larger than 0.
      #
      # Default:
      #  5
      ########################################
      #bootstrapDelay=5


      ########################################
      # How many seconds between each time we check the temporary errors folder.
      # The value must be larger than 0.
      #
      # Default:
      #  60
      ########################################
      #temporaryErrorPollInterval=

  /opt/escenic/changelog-daemon-2.0.0-3/config/Agent.properties:
    mode: "000644"
    owner: root
    group: root
    content: |

      $class=com.escenic.changelog.agent.ExecuteAgent

      # Command to run (must be in PATH, absolute, or relative to the working
      # directory.) The command must consume its STDIN, as it will receive a
      # (complete) XML document corresponding to the atom entry that appeared
      # in the changelog.
      command=./executible.sh
      directory=.
      environment.CHANGELOG_USERNAME=${./Daemon.username}

      # To inject the Daemon's username and password properties as environment variables,
      # uncomment the following two lines:
      #
      # environment.CHANGELOG_USERNAME=${./Daemon.username}
      # environment.CHANGELOG_PASSWORD=${./Daemon.password}

  /opt/escenic/changelog-daemon-2.0.0-3/executible.sh:
    mode: "000644"
    owner: root
    group: root
    content: |
    
    #!/bin/bash

    data=$(cat)
    request_url="http://localhost:9494"
    rep=$(curl -X POST -d "$data" "$request_url")
    status=$?
    echo $status
