// SPDX-License-Identifier: MIT
pragma solidity >=0.4.12 <0.9.0;

/** 
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
        // init contract owner
        owner = msg.sender;
        // put the owner into admin list
        admins.push(owner);
    }

    /**
     * Declare one modifier with admin role
     */
    modifier isAdmin() {
        // check if the sender is in the admin list
        require(existAdmin(msg.sender), "have no privilege operate!");
        _;
    }

    /**
     * Add admin address into admin list
     * @param admin admin address
     */
    function addAdmin(address admin) public isAdmin {
        require(!existAdmin(admin), "this address already exists!");
        admins.push(admin);
    }

    /**
     * Check if one address already exist
     * @param admin 需要校验的管理员地址
     */
    function existAdmin(address admin) private returns (bool) {
        for (uint i = 0; i < admins.length; i++) {
            if (admins[i] == admin) {
                return true;
            }
        }
        return false;
    }

    /**
     * EOA address deposit
     */
    function deposit() public payable {
        require(msg.value > 0, "deposit amount must be greater than 0!");
        deposits[msg.sender] += msg.value;
        // sort after deposit
        deposit_sort(msg.sender);
    }

    /**
     * Query the address balances
     */
    function balances() public view returns (uint256) {
        return deposits[msg.sender];
    }

    /**
     * Withdraw the deposit, and only admin have the privileges
     * @param amount
     */
    function withdrwal(
        address target,
        uint256 amount
    ) public isAdmin returns (bool) {
        // check the withdraw amount
        require(amount > 0, "withdraw amount must greater than 0");

        // check the deposit amount
        require(amount <= deposits[target], "this address have no enough balance");

        // transfer to the EOA address
        payable(target).transfer(amount);

        // deduct the deposit amount
        deposits[target] -= amount;

        // sort after the withdraw
        withdraw_sort(target);

        return true;
    }

    /**
     * Sort the address after deposit
     * @param target
     */
    function deposit_sort(address target) private {
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

    /**
     * Sort the address after withdraw
     * @param target
     */
    function withdraw_sort(address target) private {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] != target) {
                continue;
            }

            if (deposits[target] == 0) {
                arr[i] = address(0);
            }

            for (uint256 j = i; j < arr.length - 1; j++) {
                address temp = arr[j];
                if (deposits[arr[j]] > deposits[arr[j + 1]]) {
                    return;
                }
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
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
