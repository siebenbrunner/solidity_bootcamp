const IPFS = require('ipfs');
const all = require('it-all');

(async () => {
  const node = await IPFS.create();

  const cid = 'QmSJCNQx58GhT79qvFAG6ZDUsSZAY2NfAaZr2A1CoxdA6u';

  const data = Buffer.concat(await all(node.cat(cid)));

  console.log(data.toString());
})();
