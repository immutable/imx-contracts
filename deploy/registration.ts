import { ethers, hardhatArguments, run } from "hardhat";
import { sleep } from "./utils";

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying Contracts with the account:", deployer.address);
  console.log("Account Balance:", (await deployer.getBalance()).toString());

  if (!hardhatArguments.network) {
    throw new Error("please pass --network");
  }
  await deploy(hardhatArguments.network);
}

async function deploy(network: string) {
  const Registration = await ethers.getContractFactory("Registration");
  const imx_address = getIMXAddress(network);
  const asset = await Registration.deploy(imx_address);
  console.log("Deployed Contract Address:", asset.address);
  console.log("Verifying contract in 5 minutes...");
  await sleep(60000 * 5);
  await run("verify:verify", {
    address: asset.address,
    constructorArguments: [imx_address],
  });
}

function getIMXAddress(network: string) {
  switch (network) {
    case "dev":
      return "0xEce6b7086134AE8894Af10Ae540473dF619b5469";
    case "ropsten":
      return "0x4527be8f31e2ebfbef4fcaddb5a17447b27d2aef";
    case "mainnet":
      return "0x5FDCCA53617f4d2b9134B29090C87D01058e27e9";
  }
  throw Error("Invalid network selected");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
