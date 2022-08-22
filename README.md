# FFI-Cipher-library

## Sub Folders

this package is made using [flutter_rust_bridge]

### 1. CIPHER_FFI_LIB

native library using these crates:

>- rsa : [RSA](https://crates.io/crates/rsa)
>- rand : [rand](https://crates.io/crates/rand) (used for random number generator for rsa)
>- once_cell : [once_cell](https://crates.io/crates/once_cell) (used to make aes core singleton to prevent extra constructor calls)
>- aes : [aes](https://crates.io/crates/aes) (used for aes core as a low level library)
>- block-padding : [block-padding](https://crates.io/crates/block-padding) (used for aes encryption/decryption padding)

### 2. CIPHER_FFI_FLUTTER

flutter package
