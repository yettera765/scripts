/**
 * simple rule parser for qx
 */

// consts
const clashPayload = "payload:"
const clashRuleHeader = "- ";
const commentHeader = "#";

// main
$done({content: parse($resource.content)})

// functions
function parse(c) { return c.split("\n").map(lineParser).join("\n") }

function lineParser(line) {
    const l = line.trim()
    const trimed = (l.indexOf(clashRuleHeader) === 0) ? l.substring(2) : l
    if (trimed.length === 0) return ""
    if (trimed.indexOf(clashPayload) === 0 ) return ""
    if (trimed.indexOf(commentHeader) === 0) return ""
    // return a processed rule 
    const parts = trimed.split(",")
    if (parts.length < 2) return ""
    return processParts(parts)
}

function processParts(parts) {
    const ruleHeader = replaceRuleTypeKey(parts[0])
    const ruleBody = trimInlineComment(parts[1])
    if (ruleHeader.indexOf("ip-cidr") !==0 && ruleBody.indexOf(":") > 0) return ""
    if (ruleHeader.indexOf("ip-cidr") !==0 && ruleBody.indexOf("/") > 0) return ""
    return formatLine(ruleHeader, ruleBody, parts)
}

function replaceRuleTypeKey(ruleTypeKey) {
    const lowered = ruleTypeKey.toLowerCase()
    const keyTest = (item) => lowered.indexOf(item) === 0
    if (keyTest("process-name")) return `# ${lowered}`
    if (keyTest("ip-cidr6")) return lowered.replace("ip-cidr6", "ip6-cidr")
    if (keyTest("domain")) return lowered.replace("domain", "host")
    return lowered
}

function trimInlineComment(line) { return line.split("#")[0].trim() }

function formatLine(qxHeader, urlPart, originParts) {
    const l = originParts.length
    if (l === 2) return `${qxHeader},${urlPart},direct`
    if (l === 3) return `${qxHeader},${urlPart},direct,${originParts[2]}`
}
