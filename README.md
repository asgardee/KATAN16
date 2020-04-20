KATAN16

This cipher builds upon the original KATAN cipher developed by Christophe De Canniere, Orr Dunkelman, and Miroslav Kneuzevic.
The key difference with this cipher is the block size (16-bit plaintext and ciphertext) and the integrated start signal.
This cipher could be implemented in space constrained devices, however, this cipher is prone to birthday attacks if the
integrated start signal is not utilized properly. For this reason I would reccomend this cipher not to be used in public
devices. The primary purpose of this project was to learn more about KATAN ciphers and to explore the flaws in 16-bit 
block cipher encryption.
