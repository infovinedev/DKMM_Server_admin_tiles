var key = "abcdefghijklmnopqrstuvxyz0123456"; // 32byte
// The initialization vector (must be 16 bytes)
var iv = [ 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34,35, 36 ];
​
// Convert text to bytes (text must be a multiple of 16 bytes)
var text = '아무거나내맘대로2342ㄴㅇㄹ2123132';
var textBytes = aesjs.utils.utf8.toBytes(text);
var mod = textBytes.length % 16;
if(mod % 16 != 0) {
 text += ''.padStart(16 - mod);
 textBytes = aesjs.utils.utf8.toBytes(text);
}
​
           
var aesCbc = new aesjs.ModeOfOperation.cbc(aesjs.utils.utf8.toBytes(key), iv);
var encryptedBytes = aesCbc.encrypt(textBytes);
​
// To print or store the binary data, you may convert it to hex
var encryptedHex = aesjs.utils.hex.fromBytes(encryptedBytes);
document.body.append(encryptedHex);
document.body.innerHTML+="<br/>";
var encryptedBytes = aesjs.utils.hex.toBytes(encryptedHex);
​
// The cipher-block chaining mode of operation maintains internal
// state, so to decrypt a new instance must be instantiated.
var aesCbc = new aesjs.ModeOfOperation.cbc(aesjs.utils.utf8.toBytes(key), iv);
var decryptedBytes = aesCbc.decrypt(encryptedBytes);
​
// Convert our bytes back into text
var decryptedText = aesjs.utils.utf8.fromBytes(decryptedBytes).trim();
document.body.append(decryptedText);