import runpod

def handler(job):
    # worker-comfyui 已内置处理逻辑，这里只是占位
    pass

runpod.serverless.start({"handler": handler})
