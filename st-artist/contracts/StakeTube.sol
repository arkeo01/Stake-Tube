// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

/// @title Attention economy for videos
/// @author Aniket Parate
/// @notice Contract implementing direct and complete payment to the artist as well as adding videos
/// @dev Current implementation just consists of tipping and distribution of the tips.
/// @dev Later Implementations include: NFTs, Streaming, Bulk transfers
contract StakeTube {

    /// @notice Structure for storing videos
    /// @dev currently ipfs is not implemented, implement using the string ipfsHash
    struct Video{
        uint videoId;
        string name;
        string description;
        address payable creator;
        // TODO: Implement IPFS
        // string ipfsHash;
    }

    /// @notice total number of videos stored currently.
    uint public totalVideos;

    /// @notice Mapping from video id to the video struct stored on blockchain
    mapping (uint => Video) public idToVideo;

    /// @notice Mapping from Video id to tippers array
    /// @dev A different mapping is created because if it would have been stored in an array as earlier, 
    /// @dev then everytime the complete video object would have been needed to be fetched which would be expensive
    mapping (uint => address payable[]) public idToTippers;

    /// @notice Event emitted after video is added using addVideo
    event videoAdded(
        uint videoId,
        address payable creator
    );

    /// @notice Event after the amount is tipped
    event tipped(
        uint videoId,
        address payable creator,
        address payable tipper
    );

    /// @dev Adds Video Details to the blockchain
    /// @dev Add the necessary require statements
    /// @param _name Name of Video
    /// @param _description Description of Video
    function addVideo(string memory _name, string memory _description) public {
        totalVideos++;
        uint _videoId = totalVideos;
        Video memory video = Video(
            _videoId,
            _name,
            _description,
            msg.sender
        );
        idToVideo[_videoId] = video;
        emit videoAdded(_videoId, msg.sender);

    }

    /// @notice Adding tipper to the corresponding video with given video Id
    /// @param _videoId Id of the video
    function addTipper(uint _videoId) private {
        idToTippers[_videoId].push(msg.sender);
    }

    /// @notice Function for tipping the creator of the video
    /// @param _videoId Id of the video
    /// @dev CAUTION Currently it is taking the index of array, to be modified to take video Id
    function tip(uint _videoId) public payable{
        Video storage myVideo = idToVideo[_videoId];
        address payable creator = myVideo.creator;
        uint myVideoId = myVideo.videoId;

        // TODO: Test requires
        require(
            idToVideo[_videoId].creator != address(0),
            "Video does not exists!"
        );

        require(
            msg.value > 0, 
            "The tip should be non-zero."
        );

        require(
            msg.sender != creator,
            "Creator of the video cannot tip themselves!"
        );

        // TODO: Require for checking if the tipper exists currently
        addTipper(_videoId);

        // TODO: Failure condition of the value transfer to be handled
        // TODO: Distribution function to be implemented.
        creator.transfer(msg.value);
        emit tipped(myVideoId, creator, msg.sender);
    }

}