# ELK_STACK_PROJECTAutomated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.


These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the "YML" file may be used to install only certain pieces of it, such as Filebeat.
Enter the playbook file. 

TODO:
Install Elk Playbook
---
  - name: Install elk
    hosts: elk
    become: true
    tasks:
      - name: max map count
        command: sysctl -w vm.max_map_count=262144

      - name: memory increase
        sysctl:
          name: vm.max_map_count
          value: "262144"
          state: present
          reload: yes

      - name: docker.io
        apt:
          update_cache: yes
          name: docker.io
          state: present

      - name: Install pip3
        apt:
          name: python3-pip
          state: present

      - name: Install Docker python module
        pip:
      name: docker
          state: present

      - name: download and launch a docker web container
        docker_container:
          name: elk
          image: sebp/elk:761
          state: started
          restart_policy: always
          published_ports:
            - 5601:5601
            - 9200:9200
            - 5044:5044

      - name: Enable docker service
        systemd:
          name: docker
          enabled: yes



Filebeat Playbook
---
- name: installing and launching filebeat
  hosts: "*"
  become: yes
  tasks:

  - name: download filebeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb

  - name: install filebeat deb
    command: dpkg -i filebeat-7.4.0-amd64.deb

  - name: drop in filebeat.yml
    copy:
      src: /etc/ansible/files/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

  - name: enable and configure system module
    command: filebeat modules enable system

  - name: setup filebeat
    command: filebeat setup

  - name: start filebeat service
    command: service filebeat start

  - name: enable service filebeat on boot
    systemd:
       name: filebeat
       enabled: yes


Metricbeat Playbook
---
- name: Install metric beat
  hosts: "*"
  become: true
  tasks:
    # Use command module
  - name: Download metricbeat
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.1-amd64.deb

    # Use command module
  - name: install metricbeat
    command: dpkg -i metricbeat-7.6.1-amd64.deb

    # Use copy module
  - name: drop in metricbeat config
    copy:
      src: /etc/ansible/files/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml

    # Use command module
  - name: enable and configure docker module for metric beat
    command: metricbeat modules enable docker

    # Use command module
  - name: setup metric beat
    command: metricbeat setup -e

    # Use command module
  - name: start metric beat
    command: sudo service metricbeat start

    # Use systemd module
  - name: enable service metricbeat on boot
    systemd:
      name: metricbeat
      enabled: yes




Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

TODO: What aspect of security do load balancers protect? A load balancer distributes traffic across different servers allowing less traffic, which could lead to a build up on any one server if a load balancer was not in use. Load balancers sit between you and the servers allowing an administrator to implement rules to restrict access, as well as enhance performance of their network.

The advantage of a jump box is that it decreases your attack surface by allowing remote connections from your cloud from a single VM.





TODO: What does Filebeat watch for? 
Filebeat watches log files and records activity from them.


TODO: What does Metricbeat record? 
Metricbeat records operating system metrics and system services.



The configuration details of each machine may be found below.

Name
Function
IP Address
Operating System
Jump Box
Gateway
10.0.0.4
Linux
Web 1
Web Server
10.0.0.11
Linux
Web 2
Web Server
10.0.0.12
Linux
Elk Server 
Log Server
10.1.0.4
Linux





Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the jump box provisioner machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
TODO: 76.232.12.19

Machines within the network can only be accessed by the Jump Box via the Ansible Container. TODO: Which machine did you allow to access your ELK VM? The machine that has access to my elk vm is my personal machine through port 5601. What was its IP address? 76.232.12.19

A summary of the access policies in place can be found in the table below.


Name
Publicly Accessible
Allowed IP Addresses
Jump Box
Yes
76.232.12.19
Ansible Container
No
Jump Box (40.118.251.143)
Load Balancer
Yes
137.135.51.77 (LBIP2)
Web-1
No
10.0.0.11
Web-2
No
10.0.0.12
Elk VM
Yes
76.232.12.19



Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because...
TODO: services running can be limited, system installation and update can be streamlined, and processes become more replicable.

The playbook implements the following tasks:
TODO: 
 installs docker.io, pip3, and the docker module.
 
The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.





Target Machines & Beats
This ELK server is configured to monitor the following machines:
TODO: 
Web 1 (10.0.0.11)
Web 2 (10.0.0.12)

We have installed the following Beats on these machines:
TODO: 
Filebeat
Metricbeat

These Beats allow us to collect the following information from each machine:
TODO: 
Filebeat is a log data shipper for local files. Installed as an agent on your servers, Filebeat monitors the log directories or specific log files, tails the files, and forwards them either to Elasticsearch or Logstash for indexing. An example of such are the logs produced from the MySQL database supporting our application.

Metricbeat collects metrics and statistics on the system. An example of such is CPU usage, which can be used to monitor the system's health.

Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the _____ file to _____.
- Update the _____ file to include...
- Run the playbook, and navigate to ____ to check that the installation worked as expected.

TODO: Answer the following questions to fill in the blanks:
Which file is the playbook? 
filebeat-config.yml
metricbeat-config.yml
Where do you copy it? 
(filebeat) Web-1(10.0.0.11) and Web-2 (10.0.0.12) /etc/filebeat/filebeat.yml
(metricbeat) Web-1 (10.0.0.11) and Web-2 (10.0.0.12) /etc/metricbeat/metricbeat.yml
Which file do you update to make Ansible run the playbook on a specific machine? 
/etc/ansible/hosts
How do I specify which machine to install the ELK server on versus which to install Filebeat on?
You specify which machine to install by updating the host files with ip addresses of web/elk servers and selecting which group to run on in ansible
Which URL do you navigate to in order to check that the ELK server is running?



Update the /etc/ansible/hosts file to include the IP address of the Elk Server VM and webservers.

Run the playbook, and navigate to http://[Elk_VM_Public_IP]:5601/app/kibana to check that the installation worked as expected.

Which file is the playbook? The Filebeat-configuration

Where do you copy it? copy /etc/ansible/files/filebeat-config.yml to /etc/filebeat/filebeat.yml

Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on? update filebeat-config.yml -- specify which machine to install by updating the host files with ip addresses of web/elk servers and selecting which group to run on in ansible.

_Which URL do you navigate to in order to check that the ELK server is running? http://[your.ELK-VM.External.IP]:5601/app/kibana.



_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._

curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.1-amd64.deb
TO DOWNLOAD PLAYBOOK^

Ansible-playbook filebeat-playbook.yml
TO RUN THE PLAYBOOK^

Kubectl apply -f deployment.yml
TO UPDATE THE FILES^
