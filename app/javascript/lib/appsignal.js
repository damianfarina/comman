import Appsignal from "@appsignal/javascript";

const key = document.querySelector("meta[name='appsignal-api-key']").content;
const revision = document.querySelector("meta[name='appsignal-revision']").content;

export const appsignal = new Appsignal({ key, revision });
