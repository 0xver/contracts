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
    Token = await ethers.getContractFactory("MyFungibleToken");
    await Token.deploy();
    var Token = await ethers.getContractFactory("MyNonFungibleToken");
    await Token.deploy();
  });
});

/**
 * @dev Tests MyFungibleToken and MyNonFungibleToken functions
 */
 describe("", function () {
  it("MyFungibleToken and MyNonFungibleToken functions", async function () {
    /**
     * @dev Contract deployments
     */

    // Gets owner address and second address
    const [addr1, addr2, addr3] = await ethers.getSigners();

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyFungibleToken");
    const MyFungibleToken = await Token.deploy();
    Token = await ethers.getContractFactory("MyNonFungibleToken");
    const MyNonFungibleToken = await Token.deploy();

    /**
     * @dev MyFungibleToken function tests
     */

    // Token balance of addr1 should equal total supply of 1 billion tokens
    expect(await MyFungibleToken.balanceOf(addr1.address)).equal(ethers.utils.parseEther("1000000000"))

    // Token total supply should equal 1 billion tokens
    expect(await MyFungibleToken.totalSupply()).equal(ethers.utils.parseEther("1000000000"))

    // Transfer half the total supply of tokens to addr2
    expect(await MyFungibleToken.transfer(addr2.address, ethers.utils.parseEther("500000000")))

    // Half the total supply of tokens should be owned by addr1
    expect(await MyFungibleToken.balanceOf(addr1.address)).equal(ethers.utils.parseEther("500000000"))

    // Half the total supply of tokens should be owned by addr2
    expect(await MyFungibleToken.balanceOf(addr2.address)).equal(ethers.utils.parseEther("500000000"))

    // Approve addr2 to spend the remaining of addr1 tokens
    await MyFungibleToken.connect(addr1).approve(addr2.address, ethers.utils.parseEther("500000000"))

    // Transfer the rest of addr1 token balance to addr2 using addr2
    await MyFungibleToken.connect(addr2).transferFrom(addr1.address, addr2.address, ethers.utils.parseEther("500000000"))

    // Token balance of addr2 should equal total supply of 1 billion tokens
    expect(await MyFungibleToken.balanceOf(addr2.address)).equal(ethers.utils.parseEther("1000000000"))

    // Stakes tokens
    await MyFungibleToken.connect(addr2).stake(ethers.utils.parseEther("1000000000"))

    // Token balance of addr2 should equal to 0
    expect(await MyFungibleToken.balanceOf(addr2.address)).equal(0)

    // Speeds up blockchain by 30 days
    await network.provider.send("evm_increaseTime", [30*86400])

    // Claims tokens
    await MyFungibleToken.connect(addr2).claim()

    // Token balance of addr2 should equal total supply of 1 billion tokens
    expect(await MyFungibleToken.balanceOf(addr2.address)).equal(ethers.utils.parseEther("1000000000"))

    /**
     * @dev MyNonFungibleToken function tests
     */

    // Token balance should equal 0
    expect(await MyNonFungibleToken.balanceOf(addr1.address)).equal(0)

    // Mints first token without royalty
    await MyNonFungibleToken.publicMint(addr1.address, "bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")

    // Token balance should equal 1
    expect(await MyNonFungibleToken.balanceOf(addr1.address)).equal(1)

    // Token URI should return correct identifier
    expect(await MyNonFungibleToken.tokenURI(0)).equal("ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")

    // Royalty for 5 ETH should be 0 ETH for tokenId #0
    expect(await MyNonFungibleToken.royaltyInfo(0, ethers.utils.parseEther("5"))).eql([addr1.address, ethers.utils.parseEther("0")])

    // Mints second token with royalty
    await MyNonFungibleToken.publicMintWithRoyalty(addr1.address, "bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi", 10)

    // Token balance should equal 2
    expect(await MyNonFungibleToken.balanceOf(addr1.address)).equal(2)

    // Token URI should return correct identifier
    expect(await MyNonFungibleToken.tokenURI(1)).equal("ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")
  
    // Royalty for 5 ETH should be 0.5 ETH for tokenId #1
    expect(await MyNonFungibleToken.royaltyInfo(1, ethers.utils.parseEther("5"))).eql([addr1.address, ethers.utils.parseEther("0.5")])

    // Owner of tokenId #1 should be addr1
    expect(await MyNonFungibleToken.ownerOf(1)).equal(addr1.address)

    await MyNonFungibleToken.connect(addr1).transferFrom(addr1.address, addr2.address, 1)

    // Owner of tokenId #1 should be addr2
    expect(await MyNonFungibleToken.ownerOf(1)).equal(addr2.address)

    // Token balance should equal 0
    expect(await MyNonFungibleToken.balanceOf(addr3.address)).equal(0)

    // Add account to whitelist
    await MyNonFungibleToken.addToWhitelist(addr3.address)

    // Whitelist mint
    await MyNonFungibleToken.connect(addr3).whitelistMint(addr3.address, "bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")

    // Token balance should equal 1
    expect(await MyNonFungibleToken.balanceOf(addr1.address)).equal(1)

    // Token URI should return correct identifier
    expect(await MyNonFungibleToken.tokenURI(2)).equal("ipfs://bafybeigdyrzt5sfp7udm7hu76uh7y26nf3efuylqabf3oclgtqy55fbzdi")
  });
});

/**
 * @dev Checks for ERC721 support for MyNonFungibleToken
 */
describe("", function () {
  it("ERC721 support for MyNonFungibleToken", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyNonFungibleToken");
    const MyNonFungibleToken = await Token.deploy();

    /**
     * @dev Check for ERC721 support
     */

    // Should return true
    expect(await MyNonFungibleToken.supportsInterface(ethers.utils . hexlify(0x80ac58cd))).equal(true)
  });
});

/**
 * @dev Checks for ERC721Metadata support for MyNonFungibleToken
 */
describe("", function () {
  it("ERC721Metadata support for MyNonFungibleToken", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyNonFungibleToken");
    const MyNonFungibleToken = await Token.deploy();

    /**
     * @dev Check for ERC721Metadata support
     */

    // Should return true
    expect(await MyNonFungibleToken.supportsInterface(ethers.utils . hexlify(0x5b5e139f))).equal(true)
  });
});

/**
 * @dev Checks for ERC721Enumerable support for MyNonFungibleToken
 */
describe("", function () {
  it("ERC721Enumerable support for MyNonFungibleToken", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyNonFungibleToken");
    const MyNonFungibleToken = await Token.deploy();

    /**
     * @dev Check for ERC721Enumerable support
     */

    // Should return true
    expect(await MyNonFungibleToken.supportsInterface(ethers.utils . hexlify(0x780e9d63))).equal(true)
  });
});

/**
 * @dev Checks for ERC2981 support for MyNonFungibleToken
 */
describe("", function () {
  it("ERC2981 support for MyNonFungibleToken", async function () {
    /**
     * @dev Contract deployments
     */

    // Deploys tokens
    var Token
    Token = await ethers.getContractFactory("MyNonFungibleToken");
    const MyNonFungibleToken = await Token.deploy();

    /**
     * @dev Check for ERC2981 support
     */

    // Should return true
    expect(await MyNonFungibleToken.supportsInterface(ethers.utils . hexlify(0x2a55205a))).equal(true)
  });
});
