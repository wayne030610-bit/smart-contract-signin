// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attendance {
    struct Student {
        bool signed;       // 是否簽到
        uint256 timestamp; // 簽到時間
    }

    mapping(address => Student) public students; // 簽到紀錄
    address[] public signedList;                 // 簽到名單
    uint256 public totalSigned;                  // 總簽到人數
    uint256 public deadline;                     // 截止時間

    event Signed(address student, uint256 time);

    // 建構子：設定簽到截止時間 (秒數)
    constructor(uint256 _duration) {
        deadline = block.timestamp + _duration;
    }

    // 簽到功能
    function signIn() public {
        require(block.timestamp <= deadline, "Sign-in closed!");
        require(!students[msg.sender].signed, "Already signed in!");


        students[msg.sender].signed = true;
        students[msg.sender].timestamp = block.timestamp;
        signedList.push(msg.sender); // 加入簽到名單
        totalSigned += 1;

        emit Signed(msg.sender, block.timestamp);
    }

    // 查詢是否簽到
    function hasSigned(address _student) public view returns (bool) {
        return students[_student].signed;
    }

    // 查詢簽到時間
    function getSignTime(address _student) public view returns (uint256) {
       require(students[_student].signed, "Not signed in yet");
        return students[_student].timestamp;
    }

    // 查詢剩餘時間
    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }

    // 查詢所有簽到名單
    function getSignedList() public view returns (address[] memory) {
        return signedList;
    }
}
