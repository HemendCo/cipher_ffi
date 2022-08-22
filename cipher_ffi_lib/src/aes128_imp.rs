#![allow(unused)]
use std::io::BufRead;

use aes::cipher::typenum::*;
use aes::cipher::{generic_array::GenericArray, BlockDecrypt, BlockEncrypt, KeyInit};
use aes::Aes128;
use once_cell::sync::Lazy;

use block_padding::{generic_array::typenum::U16, Padding, Pkcs7};

static mut AES128_CORE: Lazy<Aes128> = Lazy::new(|| Aes128::new(&GenericArray::from([0; 16])));

pub fn aes128_update_key(key: Vec<u8>) {
    let key: GenericArray<u8, UInt<UInt<UInt<UInt<UInt<UTerm, B1>, B0>, B0>, B0>, B0>> =
        GenericArray::from(cast_vector2array16(key));
    let new_core = &Aes128::new(&key);
    unsafe { AES128_CORE.clone_from(new_core) };
}
pub fn aes128_encrypt(data: Vec<u8>) -> Vec<u8> {
    let processing_data = vector_breakdown(data);
    let mut output: Vec<Vec<u8>> = Vec::new();
    for p_data in processing_data {
        output.push(encrypt(p_data));
    }
    concat_vector(output)
}
pub fn aes128_decrypt(data: Vec<u8>) -> Vec<u8> {
    let processing_data = vector_breakdown(data);
    let mut output: Vec<Vec<u8>> = Vec::new();

    if let Some((last, elements)) = processing_data.split_last() {
        for p_data in elements {
            output.push(decrypt(p_data.to_vec()));
        }
        output.push(pkcs7_unpad(decrypt(last.to_vec())));
    }

    concat_vector(output)
}

fn encrypt(data: Vec<u8>) -> Vec<u8> {
    let block = &mut GenericArray::from(cast_vector2array16(data));

    unsafe {
        AES128_CORE.encrypt_block(block);
    };
    cast_array16_2vector(block.as_slice())
}
fn decrypt(data: Vec<u8>) -> Vec<u8> {
    let block = &mut GenericArray::from(cast_vector2array16(data));

    unsafe {
        AES128_CORE.decrypt_block(block);
    };
    cast_array16_2vector(block.as_slice())
}
fn vector_breakdown(data: Vec<u8>) -> Vec<Vec<u8>> {
    let mut output = Vec::new();
    let mut index = 0;
    while index < data.len() {
        let mut dst = index + 16;
        if dst > data.len() {
            dst = data.len()
        }
        output.push(data[index..dst].to_vec());
        index += 16;
    }
    let last_part_len = output.last().unwrap().len();
    if last_part_len != 16 {
        let last_part = pkcs7_pad(output.last().unwrap().to_vec());
        output.remove(index / 16 - 1);
        output.push(last_part);
    }
    output
}
fn concat_vector(data: Vec<Vec<u8>>) -> Vec<u8> {
    let mut output: &mut Vec<u8> = &mut Vec::new();

    for item in data {
        output.extend(item);
    }

    output.to_vec()
}
fn cast_vector2array16(vec: Vec<u8>) -> [u8; 16] {
    let mut array = [0u8; 16];

    for i in 0..16 {
        array[i] = vec[i];
    }
    array
}
fn cast_array16_2vector(array: &[u8]) -> Vec<u8> {
    let mut vec = Vec::new();
    for i in 0..16 {
        vec.push(array[i]);
    }
    vec
}
fn pkcs7_unpad(data: Vec<u8>) -> Vec<u8> {
    let data_len = data.len();
    let data: &[u8] = data.as_slice();
    let mut block: GenericArray<u8, U16> = [0xff; 16].into();
    block[..data_len].copy_from_slice(data);
    let res = match Pkcs7::unpad(&block) {
        Ok(res) => res,
        Err(e) => {
            println!("data is not padded",);
            return data.to_vec();
        }
    };
    res.to_vec()
}
fn pkcs7_pad(data: Vec<u8>) -> Vec<u8> {
    let pos = data.len();
    let data: &[u8] = data.as_slice();
    let mut block: GenericArray<u8, U16> = [0xff; 16].into();
    block[..pos].copy_from_slice(data);
    Pkcs7::pad(&mut block, pos);
    Vec::from_iter(block.into_iter())
}
