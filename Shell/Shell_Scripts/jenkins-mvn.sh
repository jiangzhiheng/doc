#-------参数start---------

. /etc/profile

#-------参数--------
function config(){

# 主机组名称
HOST_GROUP=

# 版本号git
git=

#发布或回滚
Status=

#选择构建环境
deploy=

#项目名称
JOB_NAME=

#工作目录
WORKSPACE=

ANSIBLE_BIN=/usr/bin/ansible

ANSIBLE_HOSTS=/etc/ansible/hosts

# 并发线程数
ANSIBLE_FORKS=1

#HOST_GROUP="192.168.31.152 192.168.31.153"
# stag_host=""
port=

}

config ;

#--------参数-----------

#-------参数end---------

#函数
#参数处理
function doParam(){
  # 处理参数
  local param=
  [ $# == 0 ] && return ;
  for param in "$@" ; do
      local paramName=`echo ${param} | awk -F'=' '{print $1}'`
      local paramValue=`echo ${param} | awk -F'=' '{print $NF}'`

      case "${paramName}" in
          -hostgroup|-hg)
              HOST_GROUP=${paramValue} ;;
          -job.name|-pn)
              JOB_NAME=${paramValue} ;;
          -ci.type|-ct)
              CI_TYPE=${paramValue} ;;
          -environmental|-e)
              ENVIRONMENTEL=${paramValue} ;;
          -ansible.hosts)
              ANSIBLE_HOSTS=/etc/ansible/${paramValue} ;;
          -ansible.forks)
              ANSIBLE_FORKS=${paramValue} ;;
          -service.port)
              port=${paramValue} ;;
          -debug.address)
              DEBUG_ADDRESS=${paramValue} ;;
          -bambooDeployVersion)
              BAMBOO_DEPLOY_VERSION=${paramValue} ;;
          -bambooBuildNumber)
              BAMBOO_BUILD_NUMBER=${paramValue} ;;              
          -deploy)
              deploy=${paramValue} ;;
          -Status)
              Status=${paramValue} ;;
          -workspace)
              WORKSPACE=${paramValue} ;;
          -git)
              git=${paramValue} ;;
          -h|-help)
              prometheus_help $(basename $0) 
              exit 0 ;;    
      esac
  done
}

doParam $@ ;

#--------校验----------
function doCheck(){

  # 校验 HOST_GROUP
  test ".${HOST_GROUP}" = . && echoPlus error "Not found host group !" && deploy_failure ;

  # 维护时间配置提醒
  #out_of_service ;
}

doCheck ;
#--------校验----------

#Deploy tomcat 

war_bak="/data/war/bak"
tomcat_deploy="/usr/local/src/tomcat-${deploy}/webapps"
#WAR_PATH="${WORKSPACE}/${MODULE_NAME}/target/*.war"
WAR_PATH="${WORKSPACE}/target/*.war"

#构建时间
TIME=$(date "+%Y-%m-%d_%H:%M:%S")


echo "构建环境:${deploy} 项目名称:${JOB_NAME} 构建时间:`date +%F` 本次上线版本:${GIT_COMMIT}" >>/data/${JOB_NAME}.log

### status deploy or rollback

##判断git是否为空，如果是为空进行提示
if [ "${git}" = "" ];then

echo "请输入git版本 #############"
exit 1

else

# 函数

#function initService(){

#部署
#mkdir -p ${war_bak}/${JOB_NAME}/${git}
#wget ${WAR_PATH}
#}

## 判断发布 or 回滚
if [ "${Status}" = "Deploy" ];then

### 判断是否为测试环境
    if [ "${deploy}" = "test" ];then
            ### 构建主机
               for i in ${HOST_GROUP}
                 do
                  
               ssh ${i} "mkdir -p ${war_bak}/${JOB_NAME}/${git}"
               	 
                 scp ${WAR_PATH} ${i}:${war_bak}/${JOB_NAME}/${git}/hello-world-war-1.0.0-$TIME.war
                 ssh ${i} rm -rf ${tomcat_deploy}/*
                 ssh ${i} cp ${war_bak}/${JOB_NAME}/${git}/hello-world-war-1.0.0-$TIME.war ${tomcat_deploy}
                 ssh ${i} /etc/init.d/tomcat-8080 restart
          ### 判断tomcat是否正常      
                     for http in `seq 1 5`
                       do
                        tomcat_status=`curl -I ${i}:${port} -s|awk -F "[ ]" '{print $2}' |sed -n '1p'`
                    if  [[ "$tomcat_status" -ne 200 ]] || [[ "$tomcat_status" = "" ]];then
                        echo -e "\033[5;34m 请稍等，服务启动中........ \033[0m"
                              sleep 15
                      else
                        echo -e "\033[5;34m 构建 ${i}环境发布正常,返回值[${tomcat_status}] \033[0m"
                              break
                      fi
                  done
          
                      if [[ "${tomcat_status}" -ne 200 ]] || [[ "${tomcat_status}" = "" ]];then
                          if [[ "${tomcat_status}" = "" ]];then
                      echo -e "\033[5;34m 构建 ${i}服务启动异常 \033[0m"
                      exit 1
                          fi
                        echo -e "\033[5;34m 构建 ${i}环境发布异常,返回值[${tomcat_status}] \033[0m"
                    fi
              done
                echo -e "\033[5;34m 本次构建${test_host}主机,本次环境 ${deploy} \033[0m"
## 判断为预发布环境
    elif [ "${deploy}" = "stag" ];then
               for i in "${stag_host}"
                 do
               ssh ${i} mkdir -p ${war_bak}/${JOB_NAME}/${git}
                 scp ${WAR_PATH} ${i}:${war_bak}/${JOB_NAME}/${git}/hello-world-war-1.0.0-$TIME.war
                 ssh ${i} rm -rf ${tomcat_deploy}/*
                 ssh ${i} cp ${war_bak}/${JOB_NAME}/${git}/hello-world-war-1.0.0-$TIME.war ${tomcat_deploy}
                 ssh ${i} /etc/init.d/tomcat-8080 restart
          ### 判断tomcat是否正常      
                     for http in `seq 1 5`
                      do
                        tomcat_status=`curl -I ${i}:${port} -s|awk -F "[ ]" '{print $2}' |sed -n '1p'`
                    if  [[ "$tomcat_status" -ne 200 ]] || [[ "$tomcat_status" = "" ]];then
                        echo -e "\033[5;34m 请稍等，服务启动中........ \033[0m"
                              sleep 10
                      else
                        echo -e "\033[5;34m 构建 ${i}环境发布正常,返回值[${tomcat_status}] \033[0m"
                              break
                      fi
                  done
          
                      if [[ "${tomcat_status}" -ne 200 ]] || [[ "${tomcat_status}" = "" ]];then
                          if [[ "${tomcat_status}" = "" ]];then
                      echo -e "\033[5;34m 构建 ${i}服务启动异常 \033[0m"
                      exit 1
                        fi
                        echo -e "\033[5;34m 构建 ${i}环境发布异常,返回值[${tomcat_status}] \033[0m"
                    fi
        done
               echo -e "\033[5;34m 本次构建${test_host}主机,本次环境 ${deploy} \033[0m"
   fi



### 回滚操作
elif [[ "${Status}" = "RollBack" ]];then
        

  ### 判断回滚环境及主机
            if [ "${deploy}" = "test" ];then
              for i in ${test_host}
                do
                 ssh ${i}  "[ -d ${war_bak}/${JOB_NAME}/${git} ]"
                      if [ $? -ne '0' ];then
                            echo -e "\033[5;34m  git commit 回滚目录不存在，环境${deploy} 错误主机${i} \033[0m"
                            exit 3
                        else
                            echo -e "\033[5;34m  准备回滚操作  本次回滚环境${deploy} 回滚主机${i} \033[0m"
                            sleep 3
                      fi
                 ssh ${i}  "mkdir -p ${war_bak}/${JOB_NAME}/${git}_${Status}_rollback/"
                 ssh ${i}  "cp -r ${tomcat_deploy}/* ${war_bak}/${JOB_NAME}/${git}_${Status}_rollback/"
                 ssh ${i}  "rm -rf ${tomcat_deploy}/*"
                 ssh ${i} "cp -r ${war_bak}/${JOB_NAME}/${git}/*.war ${tomcat_deploy}/"
                 ssh ${i} /etc/init.d/tomcat-8080 restart
                   ### 判断tomcat是否正常      
              for http in `seq 1 5`
                do
                 tomcat_status=`curl -I ${i}:${port} -s|awk -F "[ ]" '{print $2}' |sed -n '1p'`
                 if  [[ "$tomcat_status" -ne 200 ]] || [[ "$tomcat_status" = "" ]];then
                        echo -e "\033[5;34m 请稍等，服务启动中........ \033[0m"
                        sleep 15
                 else
                        echo -e "\033[5;34m 构建 ${i}环境发布正常,返回值[${tomcat_status}] \033[0m"
                        break
                 fi
              done
          
                  if [[ "${tomcat_status}" -ne 200 ]] || [[ "${tomcat_status}" = "" ]];then
                    if [[ "${tomcat_status}" = "" ]];then
                      echo -e "\033[5;34m 构建 ${i}服务启动异常 \033[0m"
                      exit 1
                    fi
                      echo -e "\033[5;34m 构建 ${i}环境发布异常,返回值[${tomcat_status}] \033[0m"
                 fi
              done

            elif [ "${deploy}" = "stag" ];then
              echo "123"
            ### 判断测试环境fi结束
            fi
    

fi

#### fi是判断是否有git地址的结束
fi