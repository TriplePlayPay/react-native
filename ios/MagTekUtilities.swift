import Foundation

struct TLV {
    let tag: String
    let length: Int
    let value: String
}

func camelCaseToCaps(_ string: String) -> String {
    return string.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression)
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .capitalized
}

func hexStringBytes(_ string: String) -> [UInt8] {
    let bytes = Array(string.utf8)
    var data: [UInt8] = []
    for i in stride(from: 1, to: bytes.count, by: 2){
        let ascii = Array<UInt8>(bytes[i - 1...i] + [0])
        let value = UInt8(strtoul(ascii, nil, 16))
        data.append(value)
    }
    return data
}

func dataToHexString(_ data: Data) -> String {
    var hexString = ""
    data.forEach { byte in
        hexString += String(format: "%02X", byte)
    }
    return hexString
}

func n12Bytes(_ amount: String) -> [UInt8] {
    let formattedString = String(format: "%12.0f", (Double(amount) ?? 0) * 100)
    return hexStringBytes(formattedString)
}

func getDateByteString() -> String {
    let dateComponents: Set<Calendar.Component> = [.month, .day, .hour, .minute, .second, .year]
    let date = Calendar.current.dateComponents(dateComponents, from: Date())
    let year = (date.year ?? 2008) - 2008
    let format = String(repeating: "%02lX", count: 5) + "%04lX"
    return String(format: format, date.month ?? 0, date.day ?? 0, date.hour ?? 0, date.minute ?? 0, date.second ?? 0, year)
}
