# ############################      RUN PIPELINE      ############################
# libpaths <- .libPaths(
#   grep(
#     paste0("biotools|", Sys.getenv("USER")),
#     .libPaths(),
#     value = TRUE,
#     invert = TRUE
#   )
# )

# path <- paste0(
#   "/usr/local/cuda/bin:",
#   "/usr/local/nvidia/bin:",
#   "/usr/local/cuda/bin:",
#   "/usr/local/sbin:",
#   "/usr/local/bin:",
#   "/usr/sbin:",
#   "/usr/bin:",
#   "/sbin:",
#   "/bin"
# )

# ld_library_path <- "/usr/local/cuda/lib64"
# cuda_home <- "/usr/local/cuda"

# .libPaths(libpaths)

# Sys.setenv(
#   "PATH" = path,
#   "LD_LIBRARY_PATH" = ld_library_path,
#   "CUDA_HOME" = cuda_home
# )

# # Check .libPaths().
# cat("Active library paths:\n")
# .libPaths()

# # Check PATH.
# cat("Active PATH:\n")
# Sys.getenv("PATH")

# # Check LD_LIBRARY_PATH
# cat("Active LD_LIBRARY_PATH:\n")
# Sys.getenv("LD_LIBRARY_PATH")

targets::tar_make()
