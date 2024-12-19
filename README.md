```shell
docker run -it --rm \
    -v $HOME/.cache/huggingface/hub/:/huggingface_hub/ \
    -p 8080:8080 \
    --entrypoint /bin/bash \
    ghcr.io/ggerganov/llama.cpp:full-b4351
```

```shell
./llama-server -m /huggingface_hub/models--bartowski--Phi-3.5-mini-instruct-GGUF/snapshots/6d70da17e749a471ccb62ade694486011a75cda3/Phi-3.5-mini-instruct-Q8_0.gguf --host 0.0.0.0 --port 8080
```

```shell
curl -X POST http://localhost:8080/completion \
-H "Content-Type: application/json" \
-d '{
  "prompt": "Tell me a joke.",
  "max_tokens": 128,
  "temperature": 0.7,
  "top_p": 0.9,
  "stream": true
}'
```
