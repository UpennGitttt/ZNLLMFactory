### 常见问题处理
- RuntimeError: Failed to import trl.trainer.dpo_trainer because of the following error (look up to see its traceback):
No module named 'torch._six'
    - 解决方法： pip3 install --upgrade deepspeed

- File "/home/tiger/.local/lib/python3.9/site-packages/httpx/_urlparse.py", line 411, in normalize_port
    raise InvalidURL(f"Invalid port: {port!r}")
httpx.InvalidURL: Invalid port: ':'
    - 解决方法：pip3 uninstall gradio

# ModelScope 模型下载指南
一些前置的指令
1. export http_proxy=http://sys-proxy-rd-relay.byted.org:8118  https_proxy=http://sys-proxy-rd-relay.byted.org:8118  no_proxy=code.byted.org
2. pip3 install modelscope

## 1. 模型下载存放地址
无论是使用命令行还是ModelScope SDK，默认模型会下载到`~/.cache/modelscope/hub`目录下。如果需要修改cache目录，可以手动指定环境变量`MODELSCOPE_CACHE`，指定后，模型将下载到该环境变量指定的目录中。

## 2. 使用命令行工具下载模型
```bash
modelscope download --help
```

输出内容如下：
```
usage: modelscope <command> [<args>] download [-h] --model MODEL [--revision REVISION] [--cache_dir CACHE_DIR] [--local_dir LOCAL_DIR] [--include [INCLUDE ...]] [--exclude [EXCLUDE ...]] [files ...]

positional arguments:
  files                 Specify relative path to the repository file(s) to download.(e.g 'tokenizer.json', 'onnx/decoder_model.onnx').

options:
  -h, --help            show this help message and exit
  --model MODEL         The model id to be downloaded.
  --revision REVISION   Revision of the model.
  --cache_dir CACHE_DIR Cache directory to save model.
  --local_dir LOCAL_DIR File will be downloaded to local location specified by local_dir, in this case, cache_dir parameter will be ignored.
  --include [INCLUDE ...]
                        Glob patterns to match files to download. Ignored if file is specified
  --exclude [EXCLUDE ...]
                        Glob patterns to exclude from files to download. Ignored if file is specified
```

### 2.1 使用示例（以 Qwen2 - 7B 模型为例）

**下载整个模型 repo（到默认 cache 地址）**
```bash
modelscope download --model 'Qwen/Qwen2-7b'
```

**下载整个模型 repo 到指定目录**
```bash
modelscope download --model 'Qwen/Qwen2-7b' --local_dir 'path/to/dir'
```

**指定下载单个文件（以 'tokenizer.json' 文件为例）**
```bash
modelscope download --model 'Qwen/Qwen2-7b' tokenizer.json
```

**指定下载多个文件**
```bash
modelscope download --model 'Qwen/Qwen2-7b' tokenizer.json config.json
```

**指定下载某些文件**
```bash
modelscope download --model 'Qwen/Qwen2-7b' --include '*.safetensors'
```

**过滤指定文件**
```bash
modelscope download --model 'Qwen/Qwen2-7b' --exclude '*.safetensors'
```

**指定下载 cache_dir**
```bash
modelscope download --model 'Qwen/Qwen2-7b' --include '*.json' --cache_dir './cache_dir'
```

模型文件将被下载在 `cache_dir/Qwen/Qwen2-7b`。

**指定下载 local_dir**
```bash
modelscope download --model 'Qwen/Qwen2-7b' --include '*.json' --local_dir './local_dir'
```

模型文件将被下载在 `./local_dir`。

> **注意**：如果`cache_dir`和`local_dir`参数同时被指定，`local_dir`优先级高，`cache_dir`将被忽略。

### 2.2 下载私有模型需要登录
使用`login`命令，在下载私有模型时，需先进行登录操作：
```bash
usage: modelscope <command> [<args>] login [-h] --token TOKEN

options:
  -h, --help     show this help message and exit
  --token TOKEN  The Access Token for modelscope.

modelscope login --token YOUR_MODELSCOPE_SDK_TOKEN
```
您可以在[我的访问令牌页面](https://www.modelscope.cn)获取SDK 令牌。

## 3. 使用 ModelScope SDK 下载模型

### 3.1 下载整个模型
```python
from modelscope.hub.snapshot_download import snapshot_download

model_dir = snapshot_download('iic/nlp_xlmr_named-entity-recognition_viet-ecommerce-title', cache_dir='path/to/local/dir', revision='v1.0.1')
```

### 3.2 指定下载单个文件
```python
from modelscope.hub.file_download import model_file_download

model_dir = model_file_download(model_id='AI-ModelScope/rwkv-4-world', file_path='RWKV-4-World-CHNtuned-7B-v1-20230709-ctx4096.pth', revision='v1.0.0')
```

### 3.3 下载私有模型
下载私有模型时，需要先进行登录：
```python
from modelscope import HubApi
from modelscope import snapshot_download

api = HubApi()
api.login('YOUR_MODELSCOPE_SDK_ACCESS_TOKEN')

# download your model, the model_path is downloaded model path.
model_path = snapshot_download(model_id='the_model_id', revision='the_model_version')
```

### 3.4 通过 SDK 加载模型触发下载
若模型已集成至 ModelScope 的 SDK 中，通过模型的加载会自动触发必要的模型下载：
```python
from modelscope.models import Model
model = Model.from_pretrained('iic/nlp_xlmr_named-entity-recognition_viet-ecommerce-title', revision='v1.0.1')
```

## 4. 使用 Git 下载模型

ModelScope 服务端的模型通过 Git 存储，在安装 Git LFS 后，可通过 git clone 的方式在本地下载模型。

### 4.1 公开模型下载
```bash
git lfs install
git clone https://www.modelscope.cn/<namespace>/<model-name>.git
# 例如: git clone https://www.modelscope.cn/iic/ofa_image-caption_coco_large_en.git
```

### 4.2 私有模型下载（前提是您有相应模型权限）

**方法 1**
```bash
git lfs install
git clone http://oauth2:your_git_token@www.modelscope.cn/<namespace>/<model-name>.git
```

**方法 2**
```bash
git clone http://your_user_name@www.modelscope.cn/<namespace>/<model-name>.git
# Password for 'http://your_user_name@modelscope.cn':
# input git token
```

### 4.3 跳过 LFS 大文件下载
如果希望跳过 LFS 大文件的下载，可以在 git clone 命令前添加`GIT_LFS_SKIP_SMUDGE=1`，来只获取 LFS 指针，而不下载实际的大文件：
```bash
GIT_LFS_SKIP_SMUDGE=1 git clone https://www.modelscope.cn/<namespace>/<model-name>.git
```

### 4.4 如何获取 git token
用您的账号登录 [ModelScope](https://www.modelscope.cn)，在个人中心 -> 访问令牌，拷贝 git token。
