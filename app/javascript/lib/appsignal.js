import Appsignal from "@appsignal/javascript";

const apiKeyMeta = document.querySelector("meta[name='appsignal-api-key']");
const revisionMeta = document.querySelector("meta[name='appsignal-revision']");

const key = apiKeyMeta?.content;
const revision = revisionMeta?.content;

export const appsignal = key ? new Appsignal({ key, revision }) : null;
