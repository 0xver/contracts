const { expect } = require("chai");
const { ethers } = require("hardhat");

/**
 * @dev Tests contract deployments
 */
 describe("", function () {
  it("Contract deployments", async function () {
    /**
     * @dev Test contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC20Token");
    await Token.deploy();
    var Token = await ethers.getContractFactory("MyERC721Token");
    await Token.deploy();
    var Token = await ethers.getContractFactory("MyERC1155Token");
    await Token.deploy();
  });
});

/**
 * @dev Tests MyERC20Token functions
 */
 describe("", function () {
  it("MyERC20Token functions", async function () {
    /**
     * @dev Contract deployments
     */

    // Gets owner address and second address
    const [addr1, addr2, addr3] = await ethers.getSigners();

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC20Token");
    const MyERC20Token = await Token.deploy();

    /**
     * @dev MyERC20Token function tests
     */

    // Token balance of addr1 should equal total supply of 1 billion tokens
    expect(await MyERC20Token.balanceOf(addr1.address)).equal(ethers.utils.parseEther("1000000000"))

    // Token total supply should equal 1 billion tokens
    expect(await MyERC20Token.totalSupply()).equal(ethers.utils.parseEther("1000000000"))

    // Transfer half the total supply of tokens to addr2
    expect(await MyERC20Token.transfer(addr2.address, ethers.utils.parseEther("500000000")))

    // Half the total supply of tokens should be owned by addr1
    expect(await MyERC20Token.balanceOf(addr1.address)).equal(ethers.utils.parseEther("500000000"))

    // Half the total supply of tokens should be owned by addr2
    expect(await MyERC20Token.balanceOf(addr2.address)).equal(ethers.utils.parseEther("500000000"))

    // Approve addr2 to spend the remaining of addr1 tokens
    await MyERC20Token.connect(addr1).approve(addr2.address, ethers.utils.parseEther("500000000"))

    // Transfer the rest of addr1 token balance to addr2 using addr2
    await MyERC20Token.connect(addr2).transferFrom(addr1.address, addr2.address, ethers.utils.parseEther("500000000"))

    // Token balance of addr2 should equal total supply of 1 billion tokens
    expect(await MyERC20Token.balanceOf(addr2.address)).equal(ethers.utils.parseEther("1000000000"))

    // Stakes tokens
    await MyERC20Token.connect(addr2).stake(ethers.utils.parseEther("1000000000"))

    // Token balance of addr2 should equal to 0
    expect(await MyERC20Token.balanceOf(addr2.address)).equal(0)

    // Speeds up blockchain by 30 days
    await network.provider.send("evm_increaseTime", [30*86400])

    // Claims tokens
    await MyERC20Token.connect(addr2).claim()

    // Token balance of addr2 should equal total supply of 1 billion tokens
    expect(await MyERC20Token.balanceOf(addr2.address)).equal(ethers.utils.parseEther("1000000000"))
  });
});

/**
 * @dev Tests MyERC721Token functions
 */
 describe("", function () {
  it("MyERC721Token functions", async function () {
    /**
     * @dev Contract deployments
     */

    // Gets owner address and second address
    const [addr1, addr2, addr3] = await ethers.getSigners();

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC721Token");
    const MyERC721Token = await Token.deploy();

    /**
     * @dev MyERC721Token function tests
     */

    // Token balance for addr1 should equal 0
    expect(await MyERC721Token.balanceOf(addr1.address)).equal(0)

    // Adds addr2 to whitelist
    await MyERC721Token.addToWhitelist(addr2.address)

    // Mint with addr2 during whitelist pre-mint
    await MyERC721Token.mint(addr2.address, 20)

    // Token balance for addr2 should equal 1
    expect(await MyERC721Token.balanceOf(addr2.address)).equal(1)

    // Token owner of ID 1 should be addr2
    expect(await MyERC721Token.ownerOf(1)).equal(addr2.address)

    // Token URI should return correct identifier
    expect(await MyERC721Token.tokenURI(1)).equal("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/1")

    // Initiate public mint
    await MyERC721Token.initiatePublicMint()

    // Mint with addr3
    await MyERC721Token.mint(addr3.address, 20)

    // Token balance for addr3 should equal 1
    expect(await MyERC721Token.balanceOf(addr3.address)).equal(1)

    // Token owner of ID 2 should be addr3
    expect(await MyERC721Token.ownerOf(2)).equal(addr3.address)

    // Token URI should return correct identifier
    expect(await MyERC721Token.tokenURI(2)).equal("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/2")
    
    // Transfer token ID 1 from addr2 to addr3
    await MyERC721Token.connect(addr2).transferFrom(addr2.address, addr3.address, 1)

    // Token owner of ID 1 should be addr2
    expect(await MyERC721Token.ownerOf(1)).equal(addr3.address)

    // Token balance for addr3 should equal 2
    expect(await MyERC721Token.balanceOf(addr3.address)).equal(2)
  });
});

/**
 * @dev Tests MyERC1155Token functions
 */
 describe("", function () {
  it("MyERC1155Token functions", async function () {
    /**
     * @dev Contract deployments
     */

    // Gets owner address and second address
    const [addr1, addr2, addr3, addr4] = await ethers.getSigners();

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC1155Token");
    const MyERC1155Token = await Token.deploy();

    /**
     * @dev MyERC1155Token function tests
     */

    // Token balance #1 for addr1 should equal 0
    expect(await MyERC1155Token.balanceOf(addr1.address, 1)).equal(0)

    // Initial mint 500 tokens for token ID #1
    await MyERC1155Token.initialMint(addr1.address, "QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/1", 500)

    // Token balance #1 for addr1 should equal 500
    expect(await MyERC1155Token.balanceOf(addr1.address, 1)).equal(500)

    // Transfer 200 tokens of token ID #1 from addr1 to addr2
    await MyERC1155Token.safeTransferFrom(addr1.address, addr2.address, 1, 200, 0x0)

    // Token balance #1 for addr1 should equal 300
    expect(await MyERC1155Token.balanceOf(addr1.address, 1)).equal(300)

    // Token balance #1 for addr2 should equal 200
    expect(await MyERC1155Token.balanceOf(addr2.address, 1)).equal(200)

    // Approve addr3 to spend the tokens of addr2
    await MyERC1155Token.connect(addr2).setApprovalForAll(addr3.address, true)

    // Check addr3 to spend the tokens of addr2
    expect(await MyERC1155Token.isApprovedForAll(addr2.address, addr3.address)).equal(true)

    // Transfer 200 tokens of token ID #1 from addr1 to addr2
    await MyERC1155Token.connect(addr3).safeTransferFrom(addr2.address, addr3.address, 1,100, 0x0)

    // Mint more tokens for ID #1 to addr4
    await MyERC1155Token.mint(addr4.address, 600)

    // Initial mint 2500 tokens for token ID #2
    await MyERC1155Token.initialMint(addr4.address, "QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/2", 2500)

    // Token balance #1 for addr3 should equal 100
    expect(await MyERC1155Token.balanceOf(addr3.address, 1)).equal(100)

    // Token balance #1 for addr4 should equal 600
    expect(await MyERC1155Token.balanceOf(addr4.address, 1)).equal(600)

    // Token balance #2 for addr4 should equal 2500
    expect(await MyERC1155Token.balanceOf(addr4.address, 2)).equal(2500)

    // Token URI for #1 should be correct identifier
    expect(await MyERC1155Token.uri(1)).equal("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/1")

    // Token URI for #2 should be correct identifier
    expect(await MyERC1155Token.uri(2)).equal("ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/2")
  });
});

/**
 * @dev Checks supports interface for MyERC721Token
 */
 describe("", function () {
  it("Supports interface for MyERC721Token", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC721Token");
    const MyERC721Token = await Token.deploy();

    /**
     * @dev Check for supports interface
     */

    // ERC165 support should return true
    expect(await MyERC721Token.supportsInterface(ethers.utils.hexlify(0x01ffc9a7))).equal(true)

    // ERC173 support should return true
    expect(await MyERC721Token.supportsInterface(ethers.utils.hexlify(0x7f5828d0))).equal(true)

    // ERC721 support should return true
    expect(await MyERC721Token.supportsInterface(ethers.utils.hexlify(0x80ac58cd))).equal(true)

    // ERC721Metadata support should return true
    expect(await MyERC721Token.supportsInterface(ethers.utils.hexlify(0x5b5e139f))).equal(true)

    // ERC721Receiver support should return true
    expect(await MyERC721Token.supportsInterface(ethers.utils.hexlify(0x150b7a02))).equal(true)

    // ERC2981 support should return true
    expect(await MyERC721Token.supportsInterface(ethers.utils.hexlify(0x2a55205a))).equal(true)
  });
});

/**
 * @dev Checks supports interface for MyERC1155Token
 */
 describe("", function () {
  it("Supports interface for MyERC1155Token", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC1155Token");
    const MyERC1155Token = await Token.deploy();

    /**
     * @dev Check for supports interface
     */

    // ERC165 support should return true
    expect(await MyERC1155Token.supportsInterface(ethers.utils.hexlify(0x01ffc9a7))).equal(true)

    // ERC173 support should return true
    expect(await MyERC1155Token.supportsInterface(ethers.utils.hexlify(0x7f5828d0))).equal(true)

    // ERC1155 support should return true
    expect(await MyERC1155Token.supportsInterface(ethers.utils.hexlify(0xd9b67a26))).equal(true)

    // ERC1155Metadata support should return true
    expect(await MyERC1155Token.supportsInterface(ethers.utils.hexlify(0x0e89341c))).equal(true)

    // ERC1155Receiver support should return true
    expect(await MyERC1155Token.supportsInterface(ethers.utils.hexlify(0x4e2312e0))).equal(true)
  });
});
