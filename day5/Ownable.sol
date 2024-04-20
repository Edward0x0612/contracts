// SPDX-License-Identifier: MIT
pragma solidity >=0.4.12 <0.9.0;

// 一个具有权限管理的父类合约
contract Ownable {
    
    address owner;

    constructor() {
        owner = msg.sender;
    }

    // 校验是否是admin或者说owner
    modifier admin() {
        // check if the sender is in the admin list
        require(msg.sender == owner, "have no privilege execute it!");
        _;
    }

    // 所有权转移给其他地址
    function transferOwner(address newOwner) public admin {
        owner = newOwner;
    }

}