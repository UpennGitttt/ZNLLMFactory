#!/bin/bash
REPO_ROOT=$(dirname $0)
cd ${REPO_ROOT}

# source /opt/tiger/llama_env/bin/activate  # 激活一个 Python 虚拟环境 /opt/tiger/llama_env/，确保使用的 Python 包是特定版本的包，不会与系统其他 Python 环境冲突。

# export HADOOP_ROOT_LOGGER="ERROR,console"
# export LIBHDFS_OPTS="-Dhadoop.root.logger=$HADOOP_ROOT_LOGGER"
# export LIBHDFS_OPTS="$LIBHDFS_OPTS -Xms512m -Xmx10g "
# export KRB5CCNAME="/tmp/krb5cc"
# export TF_CPP_MIN_LOG_LEVEL="2"
# export MKL_THREADING_LAYER="GNU"
# export NCCL_IB_GID_INDEX="3"
# export NCCL_IB_DISABLE="0"
# export NCCL_IB_HCA="mlx5_2:1"
# export NCCL_SOCKET_IFNAME="eth0"
# export ARNOLD_FRAMEWORK="pytorch"
# export NCCL_DEBUG=ERROR  # NCCL 调试级别，设置为 ERROR，只显示错误。

# export NPROC_PER_NODE=$(python -c "import torch;print(torch.cuda.device_count())")

# master_address=$METIS_WORKER_0_HOST  # 主节点地址，来自环境变量 METIS_WORKER_0_HOST。
# num_processes_per_worker=$NPROC_PER_NODE  # 每个工作节点的进程数，通过前面设置的 NPROC_PER_NODE 获得。
# num_workers=$ARNOLD_WORKER_NUM  # 总工作节点数，来自环境变量 ARNOLD_WORKER_NUM。
# worker_rank=$ARNOLD_ID  # 当前节点的序号（rank），来自环境变量 ARNOLD_ID。
# master_port=$(python -m src.tool get_rand_port $ARNOLD_TRIAL_ID $num_workers)  # 随机生成的端口号，用于节点间通信。

# accelerate_yaml=$(python -m src.tool split_accelerate_yaml "$@" $master_address $num_processes_per_worker $num_workers $worker_rank $master_port)
# model_yaml=$(python -m src.tool split_model_yaml "$@")
# benchmark_yaml=$(python -m src.tool split_benchmark_yaml "$@")
# inference_yaml=$(python -m src.tool split_inference_yaml "$@")
# distributed_type=$(python -m src.tool get_distribute_type "$@")

# target_script="src/train_bash.py"

# if [ $num_workers -gt 1 ] && [ "$distributed_type"="DEEPSPEED" ]; then
#     echo "机器数量大于1，且使用DEEPSPEED作为多机引擎训练，生成hostfile！"
#     new_content="\                        if '=' not in var: continue"
#     file_path=/opt/tiger/llama_env/lib/python3.10/site-packages/deepspeed/launcher/runner.py
#     sed -i "559a ${new_content}" $file_path

#     bash $ARNOLD_ENTRYPOINT_DIR/tools/gen_hostfile.sh
#     if [ $worker_rank -eq 0 ]; then
#         echo "DEEPSPEED作为多机引擎训练，该机器为主节点，运行训练脚本！"
#         accelerate launch --config_file $accelerate_yaml \
#         $target_script $model_yaml
#     fi
# else
#     accelerate launch --config_file $accelerate_yaml \
#         $target_script $model_yaml
# fi

# if [ -n "$benchmark_yaml" ]; then
# echo "进行benchmark评测！！"
# num_gpu_per_task=$(python -m src.tool get_num_gpus_pertask "$benchmark_yaml")
# python -m src.tool eval_mp $benchmark_yaml $num_processes_per_worker $num_workers $worker_rank $num_gpu_per_task
# fi

# if [ -n "$inference_yaml" ]; then
# echo "进行inference推理！！"
# num_gpu_per_task=$(python -m src.tool get_num_gpus_pertask "$inference_yaml")
# python -m src.tool inference_mp $inference_yaml $num_processes_per_worker $num_workers $worker_rank $num_gpu_per_task
# fi

