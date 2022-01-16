async function main() {
  // Gets deployer address
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contract(s) with the account:", deployer.address, "\n");

  // Creates Token variable
  var Token

  // Deploys MyFungibleToken
  Token = await ethers.getContractFactory("MyFungibleToken");
  const MyFungibleToken = await Token.deploy();
  console.log("Deployed MyFungibleToken", (MyFungibleToken.address).toString(), "\n");

  // Deploys MyNonFungibleToken
  Token = await ethers.getContractFactory("MyNonFungibleToken");
  const MyNonFungibleToken = await Token.deploy();
  console.log("Deployed MyNonFungibleToken", (MyNonFungibleToken.address).toString(), "\n");
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
