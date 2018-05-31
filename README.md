Red Hat OS custom environment config
--------------------------------------------------------

#### for CentOS 6.x、CentOS 7.x、Fedora 25+

#### Kernel mainline & longterm version update

##### Latest release: [redhat_init_efi_180530.tgz](https://github.com/StarKfeirchris/redhat_init_efi/raw/master/release/redhat_init_efi_180530.tgz)

### File explain
 * **redhat_init.sh:** Main configure file, repeatable execution.
 
 * **verify.sh:** Verifying the results of using `redhat_init.sh`.
 
 * **kernel_update_ml.sh:** Update mainline linux kernel. (from ELRepo)
 
 * **kernel_update_lt.sh:** Update longterm linux kernel. (from ELRepo, currently is `4.4.x`)

### Prompt color、Show History Time
![](https://i.imgur.com/AUv9WH6.png)  
Prompt font is [monofur](https://github.com/powerline/fonts/tree/master/Monofur)
