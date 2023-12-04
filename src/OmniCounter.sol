// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma abicoder v2;

import "lib/solidity-examples/contracts/lzApp/NonblockingLzApp.sol";

/// @title A LayerZero example sending a cross chain message from a source chain to a destination chain to increment a counter
contract OmniCounter is NonblockingLzApp {
    bytes public constant PAYLOAD = "\x01\x02\x03\x04";
    uint256 public counter;

    constructor(address _lzEndpoint) NonblockingLzApp(_lzEndpoint) Ownable(msg.sender) {}

    function _nonblockingLzReceive(uint16, bytes memory, uint64, bytes memory) internal override {
        counter += 1;
    }

    function incrementCounter(uint16 _dstChainId) public payable {
        _lzSend(_dstChainId, PAYLOAD, payable(msg.sender), address(0x0), bytes(""), msg.value);
    }
}
