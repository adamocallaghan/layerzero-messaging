// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

// This line imports the NonblockingLzApp contract from LayerZero's solidity-examples Github repo.
import "@layerzero-contracts/lzApp/NonblockingLzApp.sol";

// This contract is inheritting from the NonblockingLzApp contract.
contract OmniMessage is NonblockingLzApp {
    // A public string variable named "data" is declared. This will be the message sent to destination.
    string public data = "Nothing received yet";

    // A uint16 variable named "destChainId" is declared to hold the LayerZero Chain Id of the destination blockchain.
    uint16 public destChainId = 10161;
    address public endpointAddress;

    //This constructor initializes the contract with our source chain's _lzEndpoint.
    constructor(address _lzEndpoint) NonblockingLzApp(_lzEndpoint) Ownable(msg.sender) {
        endpointAddress = _lzEndpoint;
    }

    // This function is called when data is received. It overrides the equivalent function in the parent contract.
    function _nonblockingLzReceive(uint16, bytes memory, uint64, bytes memory _payload) internal override {
        // The LayerZero _payload (message) is decoded as a string and stored in the "data" variable.
        data = abi.decode(_payload, (string));
    }

    // This function is called to send the data string to the destination.
    // It's payable, so that we can use our native gas token to pay for gas fees.
    function send(string memory _message) public payable {
        // The message is encoded as bytes and stored in the "payload" variable.
        bytes memory payload = abi.encode(_message);

        // The data is sent using the parent contract's _lzSend function.
        _lzSend(destChainId, payload, payable(msg.sender), address(0x0), bytes(""), msg.value);
    }

    // This function allows the contract owner to designate another contract address to trust.
    // It can only be called by the owner due to the "onlyOwner" modifier.
    // NOTE: In standard LayerZero contract's, this is done through SetTrustedRemote.
    function trustAddress(address _otherContract) public onlyOwner {
        trustedRemoteLookup[destChainId] = abi.encodePacked(_otherContract, address(this));
    }
}
