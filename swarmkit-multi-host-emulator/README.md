# Ansible command


### Setup emulation hosts

Edit the ansible inventory file ``./ansible/inventory/hosts``; add
IP address to each group.

### Install docker in the emulation hosts

```bash
 ansible-playbook  -i ansible/inventory/hosts ansible/emulation_experiment.yml -e action=install
```


### Deploy the experiments on the emulation hosts

```bash
 ansible-playbook  -i ansible/inventory/hosts ansible/emulation_experiment.yml -e action=deploy
```

### Collect the log files from all the emulation hosts

```bash
 ansible-playbook  -i ansible/inventory/hosts ansible/emulation_experiment.yml -e action=collect
```



### Clean up environment

```bash
 ansible-playbook  -i ansible/inventory/hosts ansible/emulation_experiment.yml -e action=clean
```

### Note: to run experiments with real hosts replace the file "emulation_experiment.yml" with "real_experiment.yml"  in the above commands
