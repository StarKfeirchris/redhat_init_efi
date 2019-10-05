Red Hat OS custom environment config
--------------------------------------------------------
#### [go to use new version](https://github.com/StarKfeirchris/Starck-linux-init)

#### for CentOS 6.x、CentOS 7.x、Fedora 25+

#### Kernel mainline & longterm version update

##### Latest release: [redhat_init_efi_190321.tgz](https://github.com/StarKfeirchris/redhat_init_efi/raw/master/release/redhat_init_efi_190321.tgz)

### File explain
 * **redhat_init.sh:** Main configure file, repeatable execution.
 
 * **verify.sh:** Verifying the results of using `redhat_init.sh`.
 
 * **kernel_update_ml.sh:** Update mainline linux kernel. (from ELRepo)
 
 * **kernel_update_lt.sh:** Update longterm linux kernel. (from ELRepo, currently is `4.4.x`)

### Prompt color、Show History Time
![](https://i.imgur.com/AUv9WH6.png)  
Prompt font is [monofur](https://github.com/powerline/fonts/tree/master/Monofur)

### How to use

1. Download latest file
```php
curl -O https://raw.githubusercontent.com/StarKfeirchris/redhat_init_efi/master/release/redhat_init_efi_190321.tgz
```

2. Unzip .tgz file
```php
tar zxvf redhat_init_efi_190321.tgz
```

3. Select one script and start.
```php
./redhat_init_efi/<script_name>.sh
```
