import GameplayKit
import UIKit

// Modern way of generating random numbers
let int1 = Int.random(in: 0...10)
let int2 = Int.random(in: 0..<10)
let double1 = Double.random(in: 1000...10000)
let float1 = Float.random(in: -100...100)

// The older ways
print(arc4random())
print(arc4random())
print(arc4random())
print(arc4random())

print(arc4random() % 6)

func RandomInt(min: Int, max: Int) -> Int {
    if max < min { return min }
    return Int(arc4random_uniform(UInt32((max - min) + 1))) + min
}

// GameplayKit random methods
print(GKRandomSource.sharedRandom().nextInt())
print(GKRandomSource.sharedRandom().nextInt(upperBound: 6))

let arc4 = GKARC4RandomSource()
arc4.nextInt(upperBound: 20)

// Maximum possible randomness
let mersenne = GKMersenneTwisterRandomSource()
mersenne.nextInt(upperBound: 20)

arc4.dropValues(1024)

let d6 = GKRandomDistribution.d6()
d6.nextInt()

let d20 = GKRandomDistribution.d20()
d20.nextInt()

let crazy = GKRandomDistribution(lowestValue: 1, highestValue: 11539)
crazy.nextInt()

let rand = GKMersenneTwisterRandomSource()
let distribution = GKRandomDistribution(randomSource: rand, lowestValue: 10, highestValue: 20)
print(distribution.nextInt())

// Anti-clustering distribution
let shuffled = GKShuffledDistribution.d6()
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())

// GKGaussianDistribution causes the random numbers to bias towards the mean average of the range
let gaussianDistribution = GKGaussianDistribution.d20()
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())
print(gaussianDistribution.nextInt())

// Fisher-Yates array shuffle algorithm
extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swapAt(i, j)
        }
    }
}

let lotteryBalls = [Int](1...49)
let shuffledBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lotteryBalls)
print(shuffledBalls[0])
print(shuffledBalls[1])
print(shuffledBalls[2])
print(shuffledBalls[3])
print(shuffledBalls[4])
print(shuffledBalls[5])

// Fixed seed value
let fixedLotteryBalls = [Int](1...49)
let fixedShuffledBalls = GKMersenneTwisterRandomSource(seed: 1001).arrayByShufflingObjects(in: fixedLotteryBalls)
print(fixedShuffledBalls[0])
print(fixedShuffledBalls[1])
print(fixedShuffledBalls[2])
print(fixedShuffledBalls[3])
print(fixedShuffledBalls[4])
print(fixedShuffledBalls[5])
