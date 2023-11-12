import Foundation

/// Dump a sequence of bytes to a `String`.
///
/// - parameter bytes: Sequence of `UInt8` values to be hex-dumped.
///
/// - returns: A `String`, which may contain newlines.
public func hexDump<S: Sequence>(
    _ bytes: S,
    bytesPerRow: Int
) -> String where S.Iterator.Element == UInt8 {
    var s = ""
    forEachHexDumpLineForBytes(bytes: bytes, bytesPerRow: bytesPerRow) { s += $0 + "\n" }
    return s
}

/// Get hex representation of a byte.
///
/// - parameter byte: A `UInt8` value.
///
/// - returns: A two-character `String` of hex digits, with leading zero if necessary.
public func hexStringForByte(byte: UInt8) -> String {
    return String(format: "%02x", UInt(byte))
}

/// Get hex representation of an array of bytes.
///
/// - parameter bytes: A sequence of `UInt8` values.
///
/// - returns: A `String` of hex codes separated by spaces.
public func hexStringForBytes<S: Sequence>(
    bytes: S
) -> String where S.Iterator.Element == UInt8
{
    return bytes.lazy.map(hexStringForByte).joined(separator: " ")
}

/// Get printable representation of character.
///
/// - parameter byte: A `UInt8` value.
///
/// - returns: A one-character `String` containing the printable representation, or "." if it is not printable.
public func printableCharacterForByte(byte: UInt8) -> String {
    return (isprint(Int32(byte)) != 0) ? String(UnicodeScalar(byte)) : "."
}

/// Get printable representation of an array of characters.
///
/// - parameter bytes: A sequence of `UInt8` values.
///
/// - returns: A `String` of characters containing the printable representations of the input bytes.
public func printableTextForBytes<S: Sequence>(
    bytes: S
) -> String where S.Iterator.Element == UInt8
{
    return bytes.lazy.map(printableCharacterForByte).joined(separator: "")
}

/// Generate hex-dump output line for a row of data.
///
/// Each line is a string consisting of an offset, hex representation
/// of the bytes, and printable ASCII representation.  There is no
/// end-of-line character included.
///
/// - parameters:
///    - offset: Numeric offset into the input data sequence.
///    - bytes: Sequence of `UInt8` values to be hex-dumped for this line.
///
/// - returns: A `String` with the format described above.

private func hexDumpLineForOffset<S: Sequence>(
    offset: Int,
    bytes: S
) -> String where S.Iterator.Element == UInt8
{
    let hex = hexStringForBytes(bytes: bytes)
    let paddedHex = String(format: "%-23s", NSString(string: hex).utf8String ?? "")
    let printable = printableTextForBytes(bytes: bytes)
    return String(format: "%08x  %@  %@", offset, paddedHex, printable)
}


/// Given a sequence of bytes, generate a series of hex-dump lines.
///
/// - parameters:
///    - bytes: Sequence of `UInt8` values to be hex-dumped.
///    - processLine: Function to be invoked for each generated line.

private func forEachHexDumpLineForBytes<S: Sequence>(
    bytes: S,
    bytesPerRow: Int,
    processLine: (String) -> ()) where S.Iterator.Element == UInt8
{
    forEachChunkOfSequence(sequence: bytes, perChunkCount: bytesPerRow) { offset, chunk in
        let line = hexDumpLineForOffset(offset: offset, bytes: chunk)
        processLine(line)
    }
}

/// Split a sequence into equal-size chunks and process each chunk.
///
/// Each chunk will have the specified number of elements, except for the last chunk,
/// which will be as long as necessary for the remainder of the data.
///
/// - parameters:
///    - sequence: Sequence of data elements.
///    - perChunkCount: Number of elements in each chunk.
///    - processChunk: Function that takes an offset into the data and array of data elements.
private func forEachChunkOfSequence<S : Sequence>(
    sequence: S,
    perChunkCount: Int,
    processChunk: (Int, [S.Iterator.Element]) -> ())
{
    var offset = 0
    var chunk = Array<S.Iterator.Element>()
    for element in sequence {
        chunk.append(element)
        if chunk.count == perChunkCount {
            processChunk(offset, chunk)
            chunk.removeAll()
            offset += perChunkCount
        }
    }
    if chunk.count > 0 {
        processChunk(offset, chunk)
    }
}
