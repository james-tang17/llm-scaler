# LLM Scaler

LLM Scaler is an GenAI solution for text generation, image generation, video generation etc. running on [Intel® Arc™ Pro B60 GPUs](https://www.intel.com/content/www/us/en/products/docs/discrete-gpus/arc/workstations/b-series/overview.html). LLM Scalar leverages standard frameworks such as vLLM, ComfyUI, Xinference etc and ensures the best performance for State-of-Art GenAI models running on Arc Pro B60 GPUs.

---

## Latest Update
- [2025.11] We released `intel/llm-scaler-vllm:0.10.2-b6` to support Qwen3-VL (Dense/MoE), Qwen3-Omni, Qwen3-30B-A3B (MoE Int4), MinerU 2.5, ERNIE-4.5-vl etc. 
- [2025.11] We released `intel/llm-scaler-vllm:0.10.2-b5` to support gpt-oss models and released `intel/llm-scaler-omni:0.1.0-b3` to support more ComfyUI workflows, and Windows installation.
- [2025.10] We released `intel/llm-scaler-omni:0.1.0-b2` to support more models with ComfyUI workflows and Xinference.
- [2025.09] We released `intel/llm-scaler-vllm:0.10.0-b3` to support more models (MinerU, MiniCPM-v-4.5 etc), and released `intel/llm-scaler-omni:0.1.0-b1` to enable first omni GenAI models using ComfyUI and Xinference on Arc Pro B60 GPU.
- [2025.08] We released `intel/llm-scaler-vllm:1.0`.



## LLM Scaler vLLM

`llm-scaler-vllm` supports running text generation models using vLLM, featuring: 

- ***CCL*** support (P2P or USM)
- ***INT4*** and ***FP8*** quantized online serving
- ***Embedding*** and ***Reranker*** model support
- ***Multi-Modal*** model support
- ***Omni*** model support
- ***Tensor Parallel***, ***Pipeline Parallel*** and ***Data Parallel***
- Finding maximum Context Length
- Multi-Modal WebUI
- BPE-Qwen tokenizer

Please follow the instructions in the [Getting Started](vllm/README.md/#1-getting-started-and-usage) to use `llm-scaler-vllm`. 

### Supported Models


| Model         | Category         | 
|-------------------|------------------|
|       DeepSeek-R1-0528-Qwen3-8B   |        language model             | 
|       DeepSeek-R1-Distill-1.5B/7B/8B/14B/32B/70B             | 
|       Qwen3-8B/14B/32B            |        language model             | 
|       DeepSeek-V2-Lite            |        language model             |
|       QwQ-32B                     |        language model             | 
|       Ministral-8B                |        language model             |
|       Mixtral-8x7B                |        language model             | 
|       Llama3.1-8B/Llama3.1-70B    |        language model             | 
|       Baichuan2-7B/13B            |        language model             | 
|       codegeex4-all-9b            |        language model             | 
|       DeepSeek-Coder-33B          |        language model             | 
|       GLM-4-0414-9B/32B           |        language model             | 
|       Seed-OSS-36B-Instruct       |        language model             | 
|       Hunyuan-0.5B/7B-Instruct    |        language model             | 
|Qwen3 30B-A3B/Coder-30B-A3B-Instruct|       language MOE model         | 
|       GLM-4.5-Air                 |        language MOE model         | 
|       Qwen2-VL-7B-Instruct        |        multimodal model           | 
|       MiniCPM-V-2.6               |        multimodal model           | 
|       MiniCPM-V-4                 |        multimodal model           | 
|       MiniCPM-V-4.5               |        multimodal model           | 
|       InternVL2-8B                |        multimodal model           | 
|       InternVL3-8B                |        multimodal model           | 
|       InternVL3_5-8B              |        multimodal model           | 
|       InternVL3_5-30B-A3B         |        multimodal MOE model       | 
|       GLM-4.1V-Thinking           |        multimodal model           | 
|       dots.ocr                    |        multimodal model           | 
|       Qwen2.5-VL 7B/32B/72B       |        multimodal model           | 
|       UI-TARS-7B-DPO              |        multimodal model           | 
|       Gemma-3-12B                 |        multimodal model           | 
|       GLM-4V-9B                   |        multimodal model           | 
|       Qwen2.5-Omni-7B             |        omni model                 | 
|       whisper-medium/large-v3-turb|        audio model                | 
|       Qwen3-Embedding             |        Embedding                  | 
|      bge-large,bge-m3,bce-base-v1 |        Embedding                  | 
|       Qwen3-Reranker              |        Rerank                     |
|       bge-reranker-large, bge-reranker-v2-m3 |  Rerank                | 



--- 


## LLM Scaler Omni (experimental)

`llm-scaler-omni` supports running image/voice/video generation etc. using ComfyUI, Xinference etc., featuring ComfyUI support (or `Omni Studio` mode) and Xinference support (or `Omni Serving` mode).  


Please follow the instructions in the [Getting Started](omni/README.md/#getting-started-with-omni-docker-image) to use `llm-scaler-omni`. 


### Omni Studio (ComfyUI WebUI interaction)

`Omni Stuido` supports Image Generation/Edit, Video Generation, Audio Generation, 3D Generation etc.  


| Model Category | Model | Type | 
|----------------------|------------|---------------|
| **Image Generation** | Qwen-Image, Qwen-Image-Edit | Text-to-Image, Image Editing | 
| **Image Generation** | Stable Diffusion 3.5 | Text-to-Image, ControlNet | 
| **Image Generation** | Flux.1, Flux.1 Kontext dev | Text-to-Image, Multi-Image Reference, ControlNet | 
| **Video Generation** | Wan2.2 TI2V 5B, Wan2.2 T2V 14B, Wan2.2 I2V 14B | Text-to-Video, Image-to-Video | 
| **Video Generation** | Wan2.2 Animate 14B | Video Animation | 
| **3D Generation** | Hunyuan3D 2.1 | Text/Image-to-3D | 
| **Audio Generation** | VoxCPM | Text-to-Speech | 


Please check [ComfyUI Support](omni/README.md/#comfyui) for more details.

### Omni Serving (OpenAI-API compatible serving)

`Omni Serving` supports Image Generation, Audio Generation etc.

- Image Generation (`/v1/images/generations`): Stable Diffusion 3.5, Flux.1-dev
- Text to Speech (`/v1/audio/speech`): Kokoro 82M
- Speech to Text (`/v1/audio/transcriptions`): whisper-large-v3

Please check [Xinference Support](omni/README.md/#xinference) for more details. 

---
## Releases
- Please check out the Docker image releases for [llm-scaler-vllm](Releases.md/#llm-scaler-vllm) and [llm-scaler-omni](Releases.md/#llm-scaler-omni)

---
## Get Support
- Please report a bug or raise a feature request by opening a [Github Issue](https://github.com/intel/llm-scaler/issues)