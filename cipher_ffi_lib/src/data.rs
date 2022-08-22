#[repr(C)]
pub struct RsaKeyPair {
    pub key_size: i32,
    pub private_key: String,
    pub public_key: String,
}
