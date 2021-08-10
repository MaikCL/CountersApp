import AltairMDKCommon

enum NewCounterAction {
    case createCounter(title: String)
    case createCounterSuccess(_ results: [Counter])
    case createCounterFailed(_ exception: NewCounterException)
}
