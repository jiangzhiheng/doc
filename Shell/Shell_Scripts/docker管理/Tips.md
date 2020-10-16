1. 删除系统中所有`Docker`镜像

   `docker image ls|awk '{if(NR>1){print $3}}'|xargs docker rmi --force`

2. 