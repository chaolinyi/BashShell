#!/bin/bash
# >>>>>>>>>>>>>>>>>>>     Task2   <<<<<<<<<<<<<<<<<<<<<<<<
# 把分散在当前目录下的所有某类文件集中收集，存放到某一个统一的目录中
#
#
# 功能： 遍历目录以及子目录，输出所有的文件状态
function getdir(){
    for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then 
            getdir $dir_or_file
        else
            echo $dir_or_file
        fi  
    done
}

# 功能： 遍历目录及子目录，并且解压缩.tar.gz文件
function de_tar(){
    for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then 
            de_tar $dir_or_file
        else
		    tarsuppix=".tar.gz"
		    isTar=$(echo $element | grep "${tarsuppix}")
		    if [[ "$isTar" != "" ]]
			then
			    #echo $dir_or_file
			    #echo $1"/"${element%%.tar.gz*}
				newdir=$1"/"${element%%.tar.gz*}
				rm -rf $newdir
			    echo $newdir
			    mkdir $newdir
				#echo "tar tar.gz file: " $element
			    tar -zpxf $dir_or_file -C $1"/"${element%%.tar.gz*}
            fi
        fi  
    done
}

# 功能： 遍历目录及子目录，并且将trace开头的文件放到同一个目录中
function move_trace(){
    for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then 
            move_trace $dir_or_file $2
        else
		    tracesprefix="trace_"
		    isTrace=$(echo $element | grep "${tracesprefix}")
		    if [[ "$isTrace" != "" ]]
			then
				echo "cp " $dir_or_file ", " $2
				cp $dir_or_file $2
            fi
        fi  
    done
}

# Step1: 遍历当前目录下的所有文件，并且将.tar.gz文件解压到相应的目录之下
ProcessDir=`cd $(dirname $0); pwd -P`
de_tar $ProcessDir

# Step2: 遍历当前文件夹下的所有文件，如果文件名以trace*开头，就把这个文件移到ProcessDir的新建的Collect文件夹
TRACE_CL=$ProcessDir"/"TRACE
rm -rf $TRACE_CL
mkdir $TRACE_CL
move_trace $ProcessDir $TRACE_CL
