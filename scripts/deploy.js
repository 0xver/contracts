async function main() {
  // Gets deployer address
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contract(s) with the account:", deployer.address, "\n");

  // Creates Token variable
  var Token

  // Deploys MyERC20Token
  Token = await ethers.getContractFactory("MyERC20Token");
  const MyERC20Token = await Token.deploy();
  console.log("Deployed MyERC20Token", (MyERC20Token.address).toString(), "\n");

  // Deploys MyERC721Token
  Token = await ethers.getContractFactory("MyERC721Token");
  const MyERC721Token = await Token.deploy();
  console.log("Deployed MyERC721Token", (MyERC721Token.address).toString(), "\n");

  // Deploys MyERC1155Token
  Token = await ethers.getContractFactory("MyERC1155Token");
  const MyERC1155Token = await Token.deploy();
  console.log("Deployed MyERC1155Token", (MyERC1155Token.address).toString(), "\n");
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
