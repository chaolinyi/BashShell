# 项目上日志的分析需要实时采集大量日志来进行分析定位。为了节省人工成本，需要提供能够快速进行日志筛查过滤的脚本，给自己进行使用。边学边写，完善自己的工具脚本。
#Task1
# 把分散到多个trace log中的某一个Radio的telog按照时间顺序拼装到一起
#
# 主要思路：
# 	1. 每一个trace log在收集的时候，名字都包含时间戳，因此，可以利用文件名字来确定文件的先后顺序；
# 	2. 每一个Radio的名称都是不同的，在trace log中记录的telog具有各自唯一标识，比如：0001BXP_0: [2018-09-12 12:24:07.616]。可以使用“0001BXP_0: [”作为筛选过滤的关键字。
# 	3. 筛选完成存放到一个文件中，然后再进行剔重操作。最后，得到该Radio的连续采集的telog日志记录。

#!/bin/bash
#find . -name "*.txt" | xargs -n1 cat > all_test ; 
#sort all_test > all_test1 | uniq all_test1 > all_test2
ProcessDir=`cd $(dirname $0); pwd -P`
echo "4 Steps will to do in following..."
# Step1. 所有trace文件内容重定向到同一个文件，输出内容不排序，不删重
find $ProcessDir -name "trace*" | xargs -n1 cat > all_trace_log_orignal
grep "0001BXP_0: \[" all_trace_log_orignal > all_trace_log_not_sort_not_uniq
echo "Step1: Redirecting all trace to a file is finished! 33% has been finished in all!"
# Step2. 对文件进行排序，输出内容只排序不删重
sort all_trace_log_not_sort_not_uniq > all_trace_log_sort_not_uniq
echo "Step2: Sort is finished! 66% has been finished in all!"
# Step3. 对文件进行删重，输出内容为排序删重后的结果
uniq all_trace_log_sort_not_uniq > all_trace_log
echo "Step3: Uniq is finished! 90% has been finished in all!"
# Step4. 删除中间文件 
rm all_trace_log_not_sort_not_uniq all_trace_log_sort_not_uniq all_trace_log_orignal
echo "Step4: Clean env is finished! 100% has been finished in all!"
# 输出已经完成标识
echo "Trace recoganization is Success!"