// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/BuyMeACoffee.sol";

contract BuyMeACoffeeTest is Test {
    BuyMeACoffee public buyMeACoffeeContract;

    function setUp() public {
        buyMeACoffeeContract = new BuyMeACoffee();
    }

    function testBuyCoffee() public {
        uint256 tip = 0.001 ether;
        buyMeACoffeeContract.buyCoffee{value: tip}("Thomas", "Hi");
        assertEq(
            tip,
            address(buyMeACoffeeContract).balance,
            "The balance of the contract is not equal to the tip"
        );

        BuyMeACoffee.Memo[] memory memos = buyMeACoffeeContract.getMemos();
        assertEq(memos.length, 1, "There should be exactly one memo");
        assertEq(memos[0].message, "Hi", "The message is not Hi");
    }

    function testTransferOwnership() public {
        assertEq(
            buyMeACoffeeContract.owner(),
            address(this),
            "The test contract is not the owner of the BuyMeACoffee contract"
        );
        address payable newOwner = payable(address(0x2222));
        buyMeACoffeeContract.transferOwnership(newOwner);
        assertEq(
            buyMeACoffeeContract.owner(),
            newOwner,
            "The test contract is not the owner of the BuyMeACoffee contract"
        );
        console.log("The new owner of the contract is", newOwner.balance);
    }

    function testWithdraw() public {
        uint256 tip = 0.1 ether;
        buyMeACoffeeContract.buyCoffee{value: tip}("Thomas", "Hi");
        address payable newOwner = payable(address(0x2222));
        uint256 oldBalance = newOwner.balance;
        buyMeACoffeeContract.transferOwnership(newOwner);
        buyMeACoffeeContract.withdrawTips();
        assertEq(
            newOwner.balance,
            oldBalance + tip,
            "The balance is not equal to the tip"
        );
    }
}
