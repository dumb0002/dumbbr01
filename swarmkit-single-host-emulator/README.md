
### Setup emulation hosts

Edit the template inventory file ``template.txt``


### Install docker in the emulation hosts

```bash
 ./install_docker.sh
```


### Deploy the experiments on the emulation hosts

```bash
 python emulator.py
```

### Collect the log files from all the emulation hosts

```bash
 ./log_parser.sh  (# total number of managers) (# total number of workers) (# total number of services)
```


### Clean up environment

```bash
 ./stop.sh
```
