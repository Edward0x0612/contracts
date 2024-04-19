// SPDX-License-Identifier: MIT
pragma solidity >=0.4.12 <0.9.0;

/*
 * Bank Contract
 * @date 2024.04.18
 * @author nicky.zhang
 */
contract BankContract {
    // declare the contract owner
    address owner;

    // admins array
    address[] admins;

    // deposits mapping
    mapping(address => uint256) deposits;

    // declare a array for get the top 3 deposits address
    address[] arr = new address[](3);

    constructor() public {
        owner = msg.sender;
    }


    /*
     * Declare one modifier with admin role
     */
    modifier isAdmin() {
        // check if the sender is in the admin list
        require(msg.sender == owner, "have no privilege operate!");
        _;
    }

    /*
     * EOA address deposit
     */
    function deposit() public payable {
        require(msg.value > 0, "deposit amount must be greater than 0!");
        // keep trace EOA transfer
        deposits[msg.sender] += msg.value;
        // sort after deposit
        sort(msg.sender);
    }

    /*
     * Query the each address balances
     */
    function getAddressDepositBalance() public view returns (uint256) {
        return deposits[msg.sender];
    }

    /*
     * Query the contract deposit balances
     */
    function getContractDepositBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /*
     * Withdraw the deposit, and only admin have the privileges
     * @param amount
     */
    function withdrwal(uint256 amount) public isAdmin returns (bool) {
        // check the withdraw amount
        require(amount > 0, "withdraw amount must greater than 0");

        // check the contract deposit amount
        require(address(this).balance >= amount, "Insufficient funds");

        // transfer to the EOA address
        payable(msg.sender).transfer(amount);

        // deduct the deposit amount
        deposits[msg.sender] -= amount;
        return true;
    }

    /*
     * Sort the address after deposit
     * @param target
     */
    function sort(address target) private {
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

    /*
     * Get the top 3 deposit address
     * @param target
     */
    function getTop3() public view returns (address[] memory) {
        return arr;
    }
}
