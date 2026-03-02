# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
# Note: All custom nodes are listed under unknown_registry and none include an aux_id (GitHub repo).
# Skipping automatic installs because we have no registry IDs or GitHub repos to clone.
# Could not resolve unknown_registry node: ModelSamplingAuraFlow (no aux_id provided)
# Could not resolve unknown_registry node: CFGNorm (no aux_id provided)
# Could not resolve unknown_registry node: TextEncodeQwenImageEdit (no aux_id provided)
# Could not resolve unknown_registry node: TextEncodeQwenImageEdit (no aux_id provided)
# Could not resolve unknown_registry node: ImageScaleToTotalPixels (no aux_id provided)
# Could not resolve unknown_registry node: LoraLoaderModelOnly (no aux_id provided)
# Could not resolve unknown_registry node: LoraLoaderModelOnly (no aux_id provided)

# download models into comfyui
RUN comfy model download --url https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors --relative-path models/clip --filename qwen_2.5_vl_7b_fp8_scaled.safetensors
RUN comfy model download --url https://huggingface.co/MonsterMMORPG/Wan_GGUF/blob/f1a9620042cc47a7b93b1f45567d40700a7c435f/qwen_image_vae.safetensors --relative-path models/vae --filename qwen_image_vae.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_fp8_e4m3fn.safetensors --relative-path models/diffusion_models --filename qwen_image_edit_fp8_e4m3fn.safetensors
# Note: original model filename included a folder name ("换装套件/"). Using basename for filename when saving.
RUN comfy model download --url https://huggingface.co/rahul7star/wan2.2Lora/blob/343e351b5f0dbc6dff6aaf7594cf7bee0b74d382/qwen_image_edit_remove-clothing_v1.0.safetensors --relative-path models/loras --filename qwen_image_edit_remove-clothing_v1.0.safetensors
RUN comfy model download --url https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-8steps-V2.0.safetensors --relative-path models/loras --filename Qwen-Image-Lightning-8steps-V2.0.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
