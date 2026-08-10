#!/usr/bin/env bash
# Pure LLM-GPU classification from text fixtures or live probe output.
# Accept full-setup target only if ≥1 LLM-capable GPU is detected.
# shellcheck shell=bash

# Returns 0 if LLM-capable GPU present, 1 otherwise.
# Args: multi-line probe text (system_profiler, nvidia-smi, lspci, etc.)
classify_llm_gpu_from_text() {
  local text="${1:-}"
  [[ -z "$text" ]] && return 1

  # NVIDIA
  if echo "$text" | grep -qiE 'nvidia-smi|NVIDIA.*GPU|CUDA Version|GeForce|Tesla|A100|H100|RTX'; then
    if echo "$text" | grep -qiE 'No devices were found|failed to initialize|NVIDIA-SMI has failed'; then
      : # fall through
    else
      return 0
    fi
  fi

  # Apple Silicon + Metal only (never bare "Type: GPU" — that matches Intel HD/Iris).
  # Require Metal Support and/or Apple M* chipset (covers M1–M9+).
  if echo "$text" | grep -qiE 'Metal Support: Metal'; then
    return 0
  fi
  if echo "$text" | grep -qiE 'Chipset Model: Apple M[0-9]|Apple M[0-9]+( Pro| Max| Ultra)?'; then
    return 0
  fi

  # AMD discrete / Instinct (LLM-capable class); not Intel integrated display GPUs
  if echo "$text" | grep -qiE 'AMD Radeon|Radeon Pro|Instinct'; then
    return 0
  fi

  return 1
}

# Human label from same text.
classify_llm_gpu_label() {
  if classify_llm_gpu_from_text "$1"; then
    echo "llm-gpu:yes"
  else
    echo "llm-gpu:no"
  fi
}

# Whether host may be a *full-setup* target (needs LLM GPU).
# Args: llm_gpu yes|no
accept_full_setup_target() {
  local flag="${1:-no}"
  [[ "$flag" == "yes" || "$flag" == "llm-gpu:yes" ]]
}
