// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import { L1ChugSplashProxy } from "../../chugsplash/L1ChugSplashProxy.sol";
import { iL1ChugSplashDeployer } from "../../chugsplash/interfaces/iL1ChugSplashDeployer.sol";

/**
 * @title ChugSplashDictator
 * @dev Like the AddressDictator, but specifically for the Proxy__OVM_L1StandardBridge. We're
 *      working on a generalized version of this but this is good enough for the moment.
 */
contract ChugSplashDictator is iL1ChugSplashDeployer {
    /*************
     * Variables *
     *************/

    // slither-disable-next-line constable-states
    bool public isUpgrading = true;
    L1ChugSplashProxy public target;
    address public finalOwner;
    bytes32 public codeHash;
    bytes32 public messengerSlotKey;
    bytes32 public messengerSlotVal;
    bytes32 public bridgeSlotKey;
    bytes32 public bridgeSlotVal;
    bytes32 public gcdSlotKey;
    bytes32 public gcdSlotVal;

    /***************
     * Constructor *
     ***************/

    constructor(
        L1ChugSplashProxy _target,
        address _finalOwner,
        bytes32 _codeHash,
        bytes32 _messengerSlotKey,
        bytes32 _messengerSlotVal,
        bytes32 _bridgeSlotKey,
        bytes32 _bridgeSlotVal,
        bytes32 _gcdSlotKey,
        bytes32 _gcdSlotVal
    ) {
        target = _target;
        finalOwner = _finalOwner;
        codeHash = _codeHash;
        messengerSlotKey = _messengerSlotKey;
        messengerSlotVal = _messengerSlotVal;
        bridgeSlotKey = _bridgeSlotKey;
        bridgeSlotVal = _bridgeSlotVal;
        gcdSlotKey = _gcdSlotKey;
        gcdSlotVal = _gcdSlotVal;
    }

    /********************
     * Public Functions *
     ********************/

    function doActions(bytes memory _code) external {
        require(keccak256(_code) == codeHash, "ChugSplashDictator: Incorrect code hash.");

        target.setCode(_code);
        target.setStorage(messengerSlotKey, messengerSlotVal);
        target.setStorage(bridgeSlotKey, bridgeSlotVal);
        target.setStorage(gcdSlotKey, gcdSlotVal);
        target.setOwner(finalOwner);
    }

    /**
     * Transfers ownership of this contract to the finalOwner.
     * Only callable by the finalOwner, which is intended to be our multisig.
     * This function shouldn't be necessary, but it gives a sense of reassurance that we can
     * recover if something really surprising goes wrong.
     */
    function returnOwnership() external {
        require(msg.sender == finalOwner, "ChugSplashDictator: only callable by finalOwner");

        target.setOwner(finalOwner);
    }
}
