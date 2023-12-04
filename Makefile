-include .env

# Deploy contracts to Sepolia & Mumbai testnets
deploy-lzapp-to-sepolia:
	forge create src/OmniMessage.sol:OmniMessage --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --constructor-args $(SEPOLIA_LZ_ENDPOINT)

deploy-lzapp-to-mumbai:
	forge create src/OmniMessage.sol:OmniMessage --rpc-url $(MUMBAI_RPC_URL) --private-key $(PRIVATE_KEY) --constructor-args $(MUMBAI_LZ_ENDPOINT)

# Set Trusted Remotes on deployed Sepolia & Mumbai contracts
set-trusted-remote-on-sepolia-contract:
	cast send $(SEPOLIA_OMNIMESSAGE_ADDRESS) "trustAddress(address)" $(MUMBAI_OMNIMESSAGE_ADDRESS) --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY)

set-trusted-remote-on-mumbai-contract:
	cast send $(MUMBAI_OMNIMESSAGE_ADDRESS) "trustAddress(address)" $(SEPOLIA_OMNIMESSAGE_ADDRESS) --rpc-url $(MUMBAI_RPC_URL) --private-key $(PRIVATE_KEY)

# Send message from Sepolia to Mumbai
send-message-from-sepolia-to-mumbai:
	cast send $(SEPOLIA_OMNIMESSAGE_ADDRESS) "send(string)" hello --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --value 12345678gwei

# Call 'data' on Mumbai contract to see our message
get-message-from-mumbai-contract:
	cast call $(MUMBAI_OMNIMESSAGE_ADDRESS) "data()(string)" --rpc-url $(MUMBAI_RPC_URL)

