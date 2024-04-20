// SPDX-License-Identifier: MIT
pragma solidity >=0.4.12 <0.9.0;

import "./Ownable.sol";

contract Bank is Ownable {

    mapping(address => uint256) deposits;

    address[] arr = new address[](3);

    // 取钱，需要校所有者权限
    function withdraw(uint256 amount) public admin returns (bool) {
        // 校验取出金额
        require(amount > 0, "withdraw amount must greater than 0");

        // 校验合约余额
        require(address(this).balance >= amount, "No enough amount");

        // 转账
        payable(msg.sender).transfer(amount);

        // 扣减该用户记录的金额
        deposits[msg.sender] -= amount;
        return true;
    }


    // 根据用户地址查询余额
    function getAddressDepositBalance() public view returns (uint256) {
        return deposits[msg.sender];
    }

    
    // 查询当前合约余额
    function getContractDepositBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 获取top3
    function getTop3() public view returns (address[] memory) {
        return arr;
    }

    // 排序
    function sort(address target) internal {
        for (uint256 i = 0; i < arr.length; i++) {
            if (deposits[arr[i]] > deposits[target]) {
                continue;
            }

            for (uint256 j = arr.length - 1; j > i; j--) {
                arr[j] = arr[j - 1];
            }
            arr[i] = target;
            break;
        }
    }



    receive() external payable virtual {
        require(msg.value > 0, "deposit amount must be greater than 0!");
        deposits[msg.sender] += msg.value;
        sort(msg.sender);
    }
}