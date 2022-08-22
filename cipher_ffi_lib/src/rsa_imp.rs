use rand::rngs::ThreadRng;
use rsa::{
    pkcs1::{DecodeRsaPrivateKey, DecodeRsaPublicKey, EncodeRsaPrivateKey, EncodeRsaPublicKey},
    pkcs8::{der::Document, LineEnding},
    PaddingScheme, PublicKey, RsaPrivateKey, RsaPublicKey,
};

use crate::data::RsaKeyPair;
pub fn rsa_generate_key(key_size: i32) -> RsaKeyPair {
    let rng: &mut ThreadRng = &mut rand::thread_rng();
    let bits: usize = key_size as usize;
    let priv_key: RsaPrivateKey = RsaPrivateKey::new(rng, bits).expect("failed to generate a key");
    let pub_key = RsaPublicKey::from(&priv_key);
    let private_key = EncodeRsaPrivateKey::to_pkcs1_der(&priv_key)
        .unwrap()
        .to_pem(LineEnding::CRLF)
        .expect("error converting to pem file");
    let public_key = EncodeRsaPublicKey::to_pkcs1_der(&pub_key)
        .unwrap()
        .to_pem(LineEnding::CRLF)
        .expect("error converting to pem file");
    RsaKeyPair {
        key_size,
        private_key,
        public_key,
    }
}
pub fn rsa_encrypt(data: Vec<u8>, public_key: String) -> Vec<u8> {
    let rng: &mut ThreadRng = &mut rand::thread_rng();
    let public_key: RsaPublicKey = DecodeRsaPublicKey::from_pkcs1_pem(public_key.as_str())
        .expect("failed to parse public key");

    let padd = PaddingScheme::new_pkcs1v15_encrypt();
    let encrypted = public_key
        .encrypt(rng, padd, &data)
        .expect("failed to encrypt message");
    encrypted
}
pub fn rsa_decrypt(data: Vec<u8>, private_key: String) -> Vec<u8> {
    let private_key: RsaPrivateKey = DecodeRsaPrivateKey::from_pkcs1_pem(private_key.as_str())
        .expect("failed to parse public key");

    let padd = PaddingScheme::new_pkcs1v15_encrypt();
    let output: Vec<u8> = private_key.decrypt(padd, &data).expect("faild to decrypt");
    output
}
