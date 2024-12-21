// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importing ERC20 standard interface for token functionality
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract LearnToEarn {

    // The ERC20 token used for rewards
    IERC20 public rewardToken;

    // Struct to store user data
    struct User {
        uint256 totalWatchTime;
        uint256 rewardPoints;
    }

    // Mapping to store user data
    mapping(address => User) public users;

    // Event to log reward issuance
    event RewardIssued(address indexed user, uint256 rewardPoints);

    // Constructor to set the reward token (the ERC20 token used for rewards)
    constructor(address _rewardToken) {
        rewardToken = IERC20(_rewardToken);
    }

    // Function to log watch time
    function logWatchTime(address user, uint256 watchTime) public {
        // Update user watch time and calculate reward points
        users[user].totalWatchTime += watchTime;
        uint256 rewardPoints = watchTime / 10;  // Example: 1 reward point for every 10 minutes watched
        users[user].rewardPoints += rewardPoints;

        // Emit an event for the reward
        emit RewardIssued(user, rewardPoints);
    }

    // Function to claim rewards
    function claimRewards() public {
        uint256 rewardAmount = users[msg.sender].rewardPoints;
        require(rewardAmount > 0, "No rewards available to claim");

        // Reset user reward points after claiming
        users[msg.sender].rewardPoints = 0;

        // Transfer the reward tokens to the user
        require(rewardToken.transfer(msg.sender, rewardAmount), "Reward transfer failed");
    }

    // Function to check user reward balance
    function getRewardBalance(address user) public view returns (uint256) {
        return users[user].rewardPoints;
    }

    // Function to check user total watch time
    function getWatchTime(address user) public view returns (uint256) {
        return users[user].totalWatchTime;
    }
}
