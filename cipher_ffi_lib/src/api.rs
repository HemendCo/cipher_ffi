use crate::{aes128_imp, aes256_imp, data, rsa_imp};

pub fn rsa_generate_key(key_size: i32) -> data::RsaKeyPair {
    rsa_imp::rsa_generate_key(key_size)
}
pub fn rsa_encrypt(data: Vec<u8>, public_key: String) -> Vec<u8> {
    rsa_imp::rsa_encrypt(data, public_key)
}
pub fn rsa_decrypt(data: Vec<u8>, private_key: String) -> Vec<u8> {
    rsa_imp::rsa_decrypt(data, private_key)
}

pub fn aes128_update_key(key: Vec<u8>) {
    aes128_imp::aes128_update_key(key)
}
pub fn aes128_encrypt(data: Vec<u8>) -> Vec<u8> {
    aes128_imp::aes128_encrypt(data)
}
pub fn aes128_decrypt(data: Vec<u8>) -> Vec<u8> {
    aes128_imp::aes128_decrypt(data)
}
pub fn aes256_update_key(key: Vec<u8>) {
    aes256_imp::aes256_update_key(key)
}
pub fn aes256_encrypt(data: Vec<u8>) -> Vec<u8> {
    aes256_imp::aes256_encrypt(data)
}
pub fn aes256_decrypt(data: Vec<u8>) -> Vec<u8> {
    aes256_imp::aes256_decrypt(data)
}
