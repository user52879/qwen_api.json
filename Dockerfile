# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# 先更新 comfy-cli 的缓存（可选，但有助于后续兼容）
RUN comfy node update-cache --mode remote || true

# 自定义节点部分保持注释（无 repo，无法自动装；后续可手动 git clone）
# Note: All custom nodes are listed under unknown_registry and none include an aux_id (GitHub repo).
# Skipping automatic installs because we have no registry IDs or GitHub repos to clone.
# Could not resolve unknown_registry node: ModelSamplingAuraFlow (no aux_id provided)
# Could not resolve unknown_registry node: CFGNorm (no aux_id provided)
# Could not resolve unknown_registry node: TextEncodeQwenImageEdit (no aux_id provided)
# Could not resolve unknown_registry node: TextEncodeQwenImageEdit (no aux_id provided)
# Could not resolve unknown_registry node: ImageScaleToTotalPixels (no aux_id provided)
# Could not resolve unknown_registry node: LoraLoaderModelOnly (no aux_id provided)
# Could not resolve unknown_registry node: LoraLoaderModelOnly (no aux_id provided)

# 下载模型到 ComfyUI 对应目录（使用 wget，更可靠；-c 支持断点续传）
# Text Encoder (CLIP / Text Encoder)
RUN mkdir -p /comfyui/models/clip && \
    wget -c -O /comfyui/models/clip/qwen_2.5_vl_7b_fp8_scaled.safetensors \
    https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors

# VAE (官方来源，推荐替换原 MonsterMMORPG 的)
RUN mkdir -p /comfyui/models/vae && \
    wget -c -O /comfyui/models/vae/qwen_image_vae.safetensors \
    https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors

# Diffusion Model for Edit
RUN mkdir -p /comfyui/models/diffusion_models && \
    wget -c -O /comfyui/models/diffusion_models/qwen_image_edit_fp8_e4m3fn.safetensors \
    https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_fp8_e4m3fn.safetensors

# LoRA: remove-clothing
RUN mkdir -p /comfyui/models/loras && \
    wget -c -O /comfyui/models/loras/qwen_image_edit_remove-clothing_v1.0.safetensors \
    https://huggingface.co/rahul7star/wan2.2Lora/resolve/343e351b5f0dbc6dff6aaf7594cf7bee0b74d382/qwen_image_edit_remove-clothing_v1.0.safetensors

# LoRA: Lightning 8 steps acceleration
RUN wget -c -O /comfyui/models/loras/Qwen-Image-Lightning-8steps-V2.0.safetensors \
    https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-8steps-V2.0.safetensors

# 如果需要预置输入文件（如参考图），取消注释并准备 input/ 目录
# COPY input/ /comfyui/input/

# 可选：清理缓存，减小镜像体积
RUN rm -rf /root/.cache/* /tmp/*
