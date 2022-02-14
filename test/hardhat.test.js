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
  });
});

/**
 * @dev Tests MyERC20Token and MyERC721Token functions
 */
 describe("", function () {
  it("MyERC20Token and MyERC721Token functions", async function () {
    /**
     * @dev Contract deployments
     */

    // Gets owner address and second address
    const [addr1, addr2, addr3] = await ethers.getSigners();

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC20Token");
    const MyERC20Token = await Token.deploy();
    Token = await ethers.getContractFactory("MyERC721Token");
    const MyERC721Token = await Token.deploy();

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

    /**
     * @dev MyERC721Token function tests
     */

    // Token balance should equal 0
    expect(await MyERC721Token.balanceOf(addr1.address)).equal(0)

    // Mints first token without royalty
    await MyERC721Token.publicMint(addr1.address, "bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")

    // Token balance should equal 1
    expect(await MyERC721Token.balanceOf(addr1.address)).equal(1)

    // Token URI should return correct identifier
    expect(await MyERC721Token.tokenURI(1)).equal("ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")

    // Royalty for 5 ETH should be 0 ETH for tokenId #1
    expect(await MyERC721Token.royaltyInfo(1, ethers.utils.parseEther("5"))).eql([addr1.address, ethers.utils.parseEther("0")])

    // Mints second token with royalty
    await MyERC721Token.publicMintWithRoyalty(addr1.address, "bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi", 10)

    // Token balance should equal 2
    expect(await MyERC721Token.balanceOf(addr1.address)).equal(2)

    // Token URI should return correct identifier
    expect(await MyERC721Token.tokenURI(2)).equal("ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")
  
    // Royalty for 5 ETH should be 0.5 ETH for tokenId #2
    expect(await MyERC721Token.royaltyInfo(2, ethers.utils.parseEther("5"))).eql([addr1.address, ethers.utils.parseEther("0.5")])

    // Owner of tokenId #2 should be addr1
    expect(await MyERC721Token.ownerOf(2)).equal(addr1.address)

    await MyERC721Token.connect(addr1).transferFrom(addr1.address, addr2.address, 2)

    // Owner of tokenId #1 should be addr2
    expect(await MyERC721Token.ownerOf(2)).equal(addr2.address)

    // Token balance should equal 0
    expect(await MyERC721Token.balanceOf(addr3.address)).equal(0)

    // Add account to whitelist
    await MyERC721Token.addToWhitelist(addr3.address)

    // Whitelist mint
    await MyERC721Token.connect(addr2).whitelistMint(addr3.address, "bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")

    // Token balance should equal 1
    expect(await MyERC721Token.balanceOf(addr1.address)).equal(1)

    // Token URI should return correct identifier
    expect(await MyERC721Token.tokenURI(2)).equal("ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")
  });
});

/**
 * @dev Checks for ERC721 support for MyERC721Token
 */
describe("", function () {
  it("ERC721 support for MyERC721Token", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC721Token");
    const MyERC721Token = await Token.deploy();

    /**
     * @dev Check for ERC721 support
     */

    // Should return true
    expect(await MyERC721Token.supportsInterface(ethers.utils . hexlify(0x80ac58cd))).equal(true)
  });
});

/**
 * @dev Checks for ERC721Metadata support for MyERC721Token
 */
describe("", function () {
  it("ERC721Metadata support for MyERC721Token", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC721Token");
    const MyERC721Token = await Token.deploy();

    /**
     * @dev Check for ERC721Metadata support
     */

    // Should return true
    expect(await MyERC721Token.supportsInterface(ethers.utils . hexlify(0x5b5e139f))).equal(true)
  });
});

/**
 * @dev Checks for ERC721Receiver support for MyERC721Token
 */
describe("", function () {
  it("ERC721Receiver support for MyERC721Token", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC721Token");
    const MyERC721Token = await Token.deploy();

    /**
     * @dev Check for ERC721Receiver support
     */

    // Should return true
    expect(await MyERC721Token.supportsInterface(ethers.utils . hexlify(0x150b7a02))).equal(true)
  });
});

/**
 * @dev Checks for ERC2981 support for MyERC721Token
 */
describe("", function () {
  it("ERC2981 support for MyERC721Token", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC721Token");
    const MyERC721Token = await Token.deploy();

    /**
     * @dev Check for ERC2981 support
     */

    // Should return true
    expect(await MyERC721Token.supportsInterface(ethers.utils . hexlify(0x2a55205a))).equal(true)
  });
});

/**
 * @dev Checks for ERC165 support for MyERC721Token
 */
 describe("", function () {
  it("ERC165 support for MyERC721Token", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyERC721Token");
    const MyERC721Token = await Token.deploy();

    /**
     * @dev Check for ERC165 support
     */

    // Should return true
    expect(await MyERC721Token.supportsInterface(ethers.utils . hexlify(0x01ffc9a7))).equal(true)
  });
});
